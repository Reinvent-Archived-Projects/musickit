//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMViewTestCase.h"
#import "VMImageStore.h"

static NSString* const CLASS_PREFIX = @"VM";
static NSString* const CLASS_SUFFIX = @"Tests";
static NSString* const TEST_PREFIX = @"test";


@implementation VMViewTestCase

- (void)setUp {
    [VMImageStore sharedInstance].foregroundColor = [UIColor blackColor];

    // Print the location of temporary directory for reference
    NSLog(@"Image test results written to\n%@", NSTemporaryDirectory());
}

- (void)testView:(UIView*)view forSelector:(SEL)selector withAccuracy:(CGFloat)accuracy {
    BOOL __block timedOut = NO;
    XCTestExpectation* expectation = [self expectationWithDescription:@"renderView"];

    UIImage* expected = [self loadTestImageForSelector:selector];
    [self renderView:view completion:^(UIImage* rendered) {
        if (timedOut)
            return;

        [expectation fulfill];

        if (rendered.size.width != expected.size.width || rendered.size.height != expected.size.height)
            XCTFail(@"View should match size of reference image");
        else
            XCTAssertEqualWithAccuracy(AIImageMeanAbosulteError(rendered, expected), 0, accuracy, @"View appearance should match test image");

        [self saveImage:rendered forSelector:selector];
    }];

    [self waitForExpectationsWithTimeout:0.5 handler:^(NSError* error) {
        timedOut = YES;
    }];
}

- (void)renderView:(UIView*)view completion:(void (^)(UIImage* image))completion {
    [view sizeToFit];
    [view layoutSubviews];
    CGSize size = view.bounds.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    [CATransaction setCompletionBlock:^{
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.);
        [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        completion(result);
    }];
}

- (UIImage*)loadTestImageForSelector:(SEL)selector {
    return [self loadTestImage:[self imageNameForSelector:selector]];
}

- (void)saveImage:(UIImage*)data forSelector:(SEL)selector {
    [self saveImage:data withName:[self imageNameForSelector:selector]];
}

- (NSString*)imageNameForSelector:(SEL)selector {
    NSMutableString* className = [NSMutableString stringWithString:NSStringFromClass([self class])];
    if ([className hasPrefix:CLASS_PREFIX])
        [className deleteCharactersInRange:NSMakeRange(0, CLASS_PREFIX.length)];
    if ([className hasSuffix:CLASS_SUFFIX])
        [className deleteCharactersInRange:NSMakeRange(className.length - CLASS_SUFFIX.length, CLASS_SUFFIX.length)];
    
    NSMutableString* testName = [NSMutableString stringWithString:NSStringFromSelector(selector)];
    if ([testName hasPrefix:TEST_PREFIX])
        [testName deleteCharactersInRange:NSMakeRange(0, TEST_PREFIX.length)];
    
    return [NSString stringWithFormat:@"%@-%@", className, testName];
}

- (UIImage*)loadTestImage:(NSString*)imageName {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* fullName = [NSString stringWithFormat:@"%@%@", imageName, [self.class imageSuffix]];
    NSString* path = [bundle pathForResource:fullName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

- (void)saveImage:(UIImage*)image withName:(NSString*)name {
    NSString* fullName = [NSString stringWithFormat:@"%@%@.png", name, [self.class imageSuffix]];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fullName];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:YES];
}

+ (NSString*)imageSuffix {
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale != 1)
        return [NSString stringWithFormat:@"@%.0fx", scale];
    return @"";
}

@end
