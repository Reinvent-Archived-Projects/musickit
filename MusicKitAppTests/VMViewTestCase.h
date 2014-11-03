//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "AIImageCompare.h"
#import <XCTest/XCTest.h>

#define VIEW_RENDER_ACCURACY 0.001


@interface VMViewTestCase : XCTestCase

- (void)testView:(UIView*)view forSelector:(SEL)selector withAccuracy:(CGFloat)accuracy;
- (void)renderView:(UIView*)view completion:(void (^)(UIImage* image))completion;

- (UIImage*)loadTestImageForSelector:(SEL)selector;
- (void)saveImage:(UIImage*)data forSelector:(SEL)selector;

@end
