//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
void renderPart(const mxml::ScoreGeometry& scoreGeometry, const mxml::PartGeometry& partGeometry, NSString* output);
void renderLayer(CGContextRef ctx, VMKScoreElementLayer* layer, CGRect frame);
CGSize computeSize(const mxml::PartGeometry& partGeometry);


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
        if ([argument hasPrefix:@"-"])
            continue;

        if (!input)
            input = argument;
        else if (!output)
            output = argument;
    }

    if (!input) {
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

        mxml::ScoreHandler handler;
        lxml::parse(is, [filename UTF8String], handler);
        return handler.result();
    } catch (mxml::dom::InvalidDataError& error) {
        NSLog(@"Error loading score '%@': %s", filePath, error.what());
        return std::unique_ptr<mxml::dom::Score>();
    }
}

std::unique_ptr<mxml::dom::Score> loadXML(NSString* filePath) {
    mxml::ScoreHandler handler;
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
    mxml::ScoreProperties scoreProperties(*score);
    std::unique_ptr<mxml::ScoreGeometry> scoreGeometry(new mxml::ScoreGeometry(*score, scoreProperties));

    VMKScoreRenderer renderer(*scoreGeometry);
    NSBitmapImageRep* rep = renderer.render();
    if (!rep)
        return false;

    NSData* data = [rep representationUsingType:NSPNGFileType properties:nil];
    [data writeToFile:output atomically:YES];

    return true;
}
