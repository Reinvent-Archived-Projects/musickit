// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "AIImageCompare.h"
#import "VMKImage.h"
#import <XCTest/XCTest.h>

extern const CGFloat kMaximumError;

struct VMKRenderingErrors {
    CGFloat maximumError;
    CGFloat colorError;
    CGFloat alphaError;
    CGFloat rms;
    CGFloat ratio;
};

@interface VMKLayerTestCase : XCTestCase

- (void)calculateRenderingErrors:(CALayer *)layer forSelector:(SEL)selector testBlock:(void (^)(VMKRenderingErrors))testBlock;
- (void)overrideLayerBackgorunds:(CALayer *)layer dictionary:(NSDictionary *)dictionary;

@end
