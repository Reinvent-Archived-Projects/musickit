// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <AppKit/AppKit.h>
#import <MusicKit/MusicKit.h>
#import <SSZipArchive/SSZipArchive.h>

#include <mxml/parsing/ScoreHandler.h>
#include <mxml/SpanFactory.h>
#include <lxml/lxml.h>

#include <iostream>
#include <fstream>

#include "VMKScoreRenderer.h"


int process(int argc, const char * argv[]);
std::unique_ptr<mxml::dom::Score> loadMXL(NSString* filePath);
std::unique_ptr<mxml::dom::Score> loadXML(NSString* filePath);
bool renderScore(NSString* path, NSString* output);
void renderPart(const mxml::ScrollScoreGeometry& scoreGeometry, const mxml::PartGeometry& partGeometry, NSString* output);
void renderLayer(CGContextRef ctx, VMKScoreElementLayer* layer, CGRect frame);
CGSize computeSize(const mxml::PartGeometry& partGeometry);
void openInPreview(NSString* output);


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        return process(argc, argv);
    }
    return 0;
}

void printUsage(int argc, const char * argv[]) {
    std::cerr << "Usage: \n";
    std::cerr << "    " << argv[0] << " <input> [<output>]\n\n";
    std::cerr << "    input   Input MusicXML file. Either a raw .xml file or a compressed .mxl file.\n";
    std::cerr << "    output  Optional output file. If not specified the input base name is used with a .png extension.\n";
}

int process(int argc, const char * argv[]) {
    NSString* input = nil;
    NSString* output = nil;
    for (int i = 1; i < argc; i += 1) {
        NSString* argument = [NSString stringWithUTF8String:argv[i]];
        if ([argument hasPrefix:@"-"]) {
            break;
        }

        if (!input)
            input = argument;
        else if (!output)
            output = argument;
    }

    if (!input && !output) {
        printUsage(argc, argv);
        return 1;
    }

    if (!output)
        output = [[input stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];

    if (!renderScore(input, output))
        return 1;

    return 0;
}

std::unique_ptr<mxml::dom::Score> loadMXL(NSString* filePath) {
    NSArray* cachePathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [cachePathArray firstObject];
    NSString* filename = [[filePath lastPathComponent] stringByDeletingPathExtension];
    NSString* destPath = [cachePath stringByAppendingPathComponent:filename];

    NSError* error;
    BOOL success = [SSZipArchive unzipFileAtPath:filePath
                                   toDestination:destPath
                                       overwrite:YES
                                        password:nil
                                           error:&error
                                        delegate:nil];
    if (error)
        NSLog(@"Error unzipping: %@", error);
    if (!success) {
        NSLog(@"Failed to unzip %@", filePath);
        return std::unique_ptr<mxml::dom::Score>();
    }

    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSArray* paths = [fileManager contentsOfDirectoryAtPath:destPath error:NULL];
    NSString* xmlFile = nil;
    for (NSString* file in paths) {
        if ([file hasSuffix:@".xml"]) {
            xmlFile = file;
            break;
        }
    }
    if (xmlFile == nil) {
        NSLog(@"Archive does not contain an xml file: %@", filePath);
        return std::unique_ptr<mxml::dom::Score>();
    }

    try {
        NSString* xmlPath = [destPath stringByAppendingPathComponent:xmlFile];
        std::ifstream is([xmlPath UTF8String]);

        mxml::parsing::ScoreHandler handler;
        lxml::parse(is, [filename UTF8String], handler);
        return handler.result();
    } catch (mxml::dom::InvalidDataError& error) {
        NSLog(@"Error loading score '%@': %s", filePath, error.what());
        return std::unique_ptr<mxml::dom::Score>();
    }
}

std::unique_ptr<mxml::dom::Score> loadXML(NSString* filePath) {
    mxml::parsing::ScoreHandler handler;
    std::ifstream is([filePath UTF8String]);
    lxml::parse(is, [filePath UTF8String], handler);
    return handler.result();
}

bool renderScore(NSString* path, NSString* output) {
    // Parse input file
    std::unique_ptr<mxml::dom::Score> score;
    if ([path hasSuffix:@".xml"]) {
        score = loadXML(path);
    } else if ([path hasSuffix:@".mxl"]) {
        score = loadMXL(path);
    } else {
        std::cerr << "File extension not recognized, assuming compressed MusicXML (.mxl).\n";
        score = loadMXL(path);
    }

    if (!score || score->parts().empty() || score->parts().front()->measures().empty())
        return false;

    // Generate geometry
    std::unique_ptr<mxml::ScrollScoreGeometry> scoreGeometry(new mxml::ScrollScoreGeometry(*score));

    VMKScoreRenderer renderer(*scoreGeometry);
    NSBitmapImageRep* rep = renderer.render();
    if (!rep)
        return false;

    NSData* data = [rep representationUsingType:NSPNGFileType properties:@{}];
    [data writeToFile:output atomically:YES];

    //openInPreview(output);

    return true;
}

void openInPreview(NSString* output) {
    NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
    NSURL* url = [NSURL fileURLWithPath: [workspace fullPathForApplication: @"Preview"]];
    NSDictionary *configuration = @{ NSWorkspaceLaunchConfigurationArguments: @[output] };
    [workspace launchApplicationAtURL: url
                              options: NSWorkspaceLaunchDefault
                        configuration: configuration
                                error: nil];
}
