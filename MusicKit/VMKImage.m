//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKImage.h"

#if TARGET_OS_IPHONE

CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef))   {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    block(context);

    VMKImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

#else

CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef))   {
    VMKImage* result = [[NSImage alloc] initWithSize:size];

    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:size.width
                             pixelsHigh:size.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    [result addRepresentation:rep];

    NSData* data = [NSBitmapImageRep TIFFRepresentationOfImageRepsInArray:[image representations]];
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGImageRef cgimage = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);

    [result lockFocus];

    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    render(ctx);

    [result unlockFocus];
    
    return result;
}

#endif
