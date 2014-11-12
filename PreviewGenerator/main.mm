//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <AppKit/AppKit.h>
#import <MusicKit/MusicKit.h>

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
bool renderScore(NSString* path, NSString* outputPrefix);


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        return process(argc, argv);
    }
    return 0;
}

void printUsage(int argc, const char * argv[]) {
    std::cout << "Usage: \n";
    std::cout << "    " << argv[0] << " <input> [<output>]\n\n";
    std::cout << "    input   Input MusicXML file.\n";
    std::cout << "    output  Optional output file. If not specified the input base name is used with a .png extension.\n";
}

int process(int argc, const char * argv[]) {
    if (argc < 2) {
        printUsage(argc, argv);
        return 1;
    }

    NSString* input = [NSString stringWithUTF8String:argv[1]];
    NSString* output;
    if (argc >= 3)
        output = [NSString stringWithUTF8String:argv[2]];
    else
        output = [[input stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];

    if (!renderScore(input, output))
        return 1;

    return 0;
}

bool renderScore(NSString* path, NSString* output) {
    // Parse input file
    mxml::ScoreHandler handler;
    std::ifstream is([path UTF8String]);
    lxml::parse(is, [path UTF8String], handler);
    std::unique_ptr<mxml::dom::Score> score = handler.result();
    if (!score || score->parts().empty() || score->parts().front()->measures().empty())
        return false;

    // Generate geometry
    std::unique_ptr<mxml::ScoreGeometry> scoreGeometry(new mxml::ScoreGeometry(*score));

    // Compute size
    CGSize size = CGSizeZero;
    for (auto& partGeometry : scoreGeometry->geometries()) {
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
    for (auto& partGeometry : scoreGeometry->geometries()) {
        int measure = 0;
        CGSize measuresSize = CGSizeZero;
        for (auto& measureGeometry : partGeometry->geometries()) {
            VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithGeometry:measureGeometry.get()];
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

        CGContextTranslateCTM(ctx, -measuresSize.width, measuresSize.height);
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
