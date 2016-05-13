// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKImage.h"
#import "VMKGeometry.h"

#if TARGET_OS_IPHONE

CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef))   {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context)
        return nil;

    block(context);

    VMKImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

#else

CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef))   {
    size = VMKRoundSize(size);
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);
    VMKImage* result = [[NSImage alloc] initWithSize:size];

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
    [result addRepresentation:rep];

    [result lockFocus];

    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    block(ctx);

    [result unlockFocus];
    
    return result;
}

@implementation NSImage (VMKExtension)

- (NSImageRep*)beestRepresentationForScreenScale {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    CGSize smallestSize = [self smallestSize];
    CGSize targetSize = CGSizeMake(smallestSize.width * scale, smallestSize.height);
    CGFloat closestWidth = smallestSize.width;
    NSImageRep* closestRep;
    for (NSImageRep* rep in self.representations) {
        if (!closestRep || std::abs(rep.pixelsWide - targetSize.width) < std::abs(rep.pixelsWide - closestWidth)) {
            closestWidth = rep.pixelsWide;
            closestRep = rep;
        }
    }
    return closestRep;
}

- (CGSize)smallestSize {
    CGSize size = CGSizeMake(HUGE_VALF, HUGE_VALF);
    for (NSImageRep* rep in self.representations) {
        if (rep.size.width < size.width)
            size = rep.size;
    }
    return size;
}

@end

#endif
