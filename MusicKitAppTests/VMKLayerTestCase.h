//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "AIImageCompare.h"
#import "VMKImage.h"
#import <XCTest/XCTest.h>

extern const CGFloat kDefaultAlphaTolerance;


@interface VMKLayerTestCase : XCTestCase

- (void)testLayer:(CALayer*)view forSelector:(SEL)selector alphaTolerance:(CGFloat)alphaTolerance;
- (void)renderLayer:(CALayer*)view completion:(void (^)(VMKImage* image))completion;

- (VMKImage*)loadTestImageForSelector:(SEL)selector;
- (void)saveImage:(VMKImage*)data forSelector:(SEL)selector;

- (void)overrideLayerBackgorunds:(CALayer *)layer dictionary:(NSDictionary *)dictionary;

@end
