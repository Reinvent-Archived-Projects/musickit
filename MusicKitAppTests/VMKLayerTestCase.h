//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "AIImageCompare.h"
#import "VMKImage.h"
#import <XCTest/XCTest.h>

#define VIEW_RENDER_ACCURACY 0.001


@interface VMKLayerTestCase : XCTestCase

- (void)testLayer:(CALayer*)view forSelector:(SEL)selector withAccuracy:(CGFloat)accuracy;
- (void)renderLayer:(CALayer*)view completion:(void (^)(VMKImage* image))completion;

- (VMKImage*)loadTestImageForSelector:(SEL)selector;
- (void)saveImage:(VMKImage*)data forSelector:(SEL)selector;

@end
