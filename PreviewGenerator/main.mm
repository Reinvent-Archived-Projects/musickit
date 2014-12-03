//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <AppKit/AppKit.h>
#import <MusicKit/MusicKit.h>
#import <SSZipArchive/SSZipArchive.h>

#include <mxml/geometry/ScoreGeometry.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/parsing/ScoreHandler.h>
#include <mxml/SpanFactory.h>
#include <lxml/lxml.h>

#include <iostream>
#include <fstream>

static const int kNumberOfMeasures = 4;
static const CGFloat kScale = 2;


int process(int argc, const char * argv[]);
std::unique_ptr<mxml::dom::Score> loadMXL(NSString* filePath);
std::unique_ptr<mxml::dom::Score> loadXML(NSString* filePath);
bool renderScore(NSString* path, NSString* outputPrefix);
CGSize computeSize(const mxml::ScoreGeometry& scoreGeometry);


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
    std::unique_ptr<mxml::ScoreGeometry> scoreGeometry(new mxml::ScoreGeometry(*score));
    CGSize size = computeSize(*scoreGeometry);
    CGSize scaledSize = CGSizeMake(std::ceil(size.width * kScale), std::ceil(size.height * kScale));

    CGRect previewBounds;
    previewBounds.size = size;

    // Create image
    VMKImage* image = [[NSImage alloc] initWithSize:size];
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:scaledSize.width
                             pixelsHigh:scaledSize.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    [image addRepresentation:rep];
    [image lockFocus];

    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextTranslateCTM(ctx, 0, size.height);
    CGContextScaleCTM(ctx, 1.f, -1.f);

    // Render
    for (auto& geometry : scoreGeometry->geometries()) {
        mxml::PartGeometry& partGeometry = static_cast<mxml::PartGeometry&>(*geometry);

        int measure = 0;
        CGSize measuresSize = CGSizeZero;
        for (auto& measureGeometry : partGeometry.measureGeometries()) {
            VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithGeometry:measureGeometry];
            [layer layoutIfNeeded];

            CGContextTranslateCTM(ctx, -layer.bounds.origin.x, -layer.bounds.origin.y);
            [layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, layer.bounds.origin.x, layer.bounds.origin.y);
            CGContextTranslateCTM(ctx, layer.bounds.size.width, 0);

            measuresSize.width += layer.bounds.size.width;
            measuresSize.height = std::max(measuresSize.height, static_cast<CGFloat>(measureGeometry->size().height));

            ++measure;
            if (measure >= kNumberOfMeasures)
                break;
        }
        CGContextTranslateCTM(ctx, -measuresSize.width, 0);

        for (auto& directionGeometry : partGeometry.directionGeometries()) {
            CGRect frame = CGRectFromRect(scoreGeometry->convertFromGeometry(directionGeometry->frame(), &partGeometry));
            frame = VMKRoundRect(frame);
            if (!CGRectIntersectsRect(frame, previewBounds))
                continue;
            
            VMKScoreElementLayer *layer = nil;
            if (const mxml::DirectionGeometry* geom = dynamic_cast<const mxml::DirectionGeometry*>(directionGeometry)) {
                layer = [[VMKDirectionLayer alloc] initWithGeometry:geom];
            }
            
            if (layer) {
                [layer layoutIfNeeded];
                CGContextTranslateCTM(ctx, frame.origin.x - layer.bounds.origin.x, frame.origin.y - layer.bounds.origin.y);
                [layer renderInContext:ctx];
                CGContextTranslateCTM(ctx, layer.bounds.origin.x - frame.origin.x, layer.bounds.origin.y - frame.origin.y);
            }
        }

        for (auto& tieGeometry : partGeometry.tieGeometries()) {
            CGRect frame = CGRectFromRect(scoreGeometry->convertFromGeometry(tieGeometry->frame(), &partGeometry));
            frame = VMKRoundRect(frame);
            if (!CGRectIntersectsRect(frame, previewBounds))
                continue;

            VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:tieGeometry];
            [layer layoutIfNeeded];

            CGFloat dx = frame.origin.x - layer.bounds.origin.x;
            CGFloat dy = frame.origin.y - layer.bounds.origin.y - mxml::PartGeometry::kStaffLineSpacing;

            CGContextTranslateCTM(ctx, dx, dy);
            [layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, -dx, -dy);
        }

        CGContextTranslateCTM(ctx, 0, measuresSize.height);
    }
    [image unlockFocus];

    // Save image
    CGImageRef cgimage = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep* newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgimage];
    [newRep setSize:[image size]];
    NSData* data = [newRep representationUsingType:NSPNGFileType properties:nil];
    [data writeToFile:output atomically:YES];

    return true;
}

CGSize computeSize(const mxml::ScoreGeometry& scoreGeometry) {
    CGSize size = CGSizeZero;
    for (auto& partGeometry : scoreGeometry.geometries()) {
        int measure = 0;
        CGSize measuresSize = CGSizeZero;
        for (auto& measureGeometry : partGeometry->geometries()) {
            measuresSize.width += measureGeometry->size().width;
            measuresSize.height = std::max(measuresSize.height, static_cast<CGFloat>(measureGeometry->size().height));

            ++measure;
            if (measure >= kNumberOfMeasures)
                break;
        }
        size.width = std::max(size.width, measuresSize.width);
        size.height += measuresSize.height;
    }
    CGSize scaledSize = CGSizeMake(std::ceil(size.width * kScale), std::ceil(size.height * kScale));
    size.width = scaledSize.width / kScale;
    size.height = scaledSize.height / kScale;

    return size;
}
