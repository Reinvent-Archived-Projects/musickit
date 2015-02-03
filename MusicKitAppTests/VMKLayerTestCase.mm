//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKGeometry.h"
#import "VMKLayerTestCase.h"
#import "VMKImageStore.h"

const CGFloat kDefaultAlphaTolerance = 0.0005;
static NSString* const CLASS_PREFIX = @"VMK";
static NSString* const CLASS_SUFFIX = @"Tests";
static NSString* const TEST_PREFIX = @"test";


@implementation VMKLayerTestCase

+ (void)load {
    // Print the location of temporary directory for reference
    NSLog(@"Image test results written to\n%@", NSTemporaryDirectory());
}

- (void)setUp {
    [VMKImageStore sharedInstance].foregroundColor = [VMKColor blackColor];
}

- (void)testLayer:(CALayer*)layer forSelector:(SEL)selector alphaTolerance:(CGFloat)alphaTolerance {
    BOOL __block timedOut = NO;
    XCTestExpectation* expectation = [self expectationWithDescription:@"renderView"];

    VMKImage* expected = [self loadTestImageForSelector:selector];
    [self renderLayer:layer completion:^(VMKImage* rendered) {
        if (timedOut)
            return;

        [expectation fulfill];

        if (rendered.size.width != expected.size.width || rendered.size.height != expected.size.height) {
            XCTFail(@"View should match size of reference image");
            return;
        }

        AIComponents components = AIImageMeanAbsoluteErrorByComponent(rendered, expected);
        CGFloat colorError = components.red + components.green + components.blue;
        CGFloat alphaError = components.alpha;

        if (colorError > 0 || alphaError > alphaTolerance) {
            CGFloat rms = AIImageRootMeanSquareError(rendered, expected);
            CGFloat ratio = AIImageDifferentPixelRatio(rendered, expected);

            NSLog(@"Image %@:", [self imageNameForSelector:selector]);
            NSLog(@"  Color MAE %f", colorError);
            NSLog(@"  Alpha MAE %f", alphaError);
            NSLog(@"  RMS %f", rms);
            NSLog(@"  Pixel ratio %f", ratio);
        }

        XCTAssertEqual(colorError, 0, @"View colors should match test image exactly");
        XCTAssertEqualWithAccuracy(alphaError, 0, alphaTolerance, @"View alpha values should match test image within the tolerance");
        [self saveImage:rendered forSelector:selector];
    }];

    [self waitForExpectationsWithTimeout:0.5 handler:^(NSError* error) {
        timedOut = YES;
    }];
}

- (void)renderLayer:(CALayer*)layer completion:(void (^)(VMKImage* image))completion {
    [layer layoutIfNeeded];
    VMKImage* result = VMKRenderImage(layer.bounds.size, ^(CGContextRef ctx) {
#if !TARGET_OS_IPHONE
        CGContextTranslateCTM(ctx, 0, layer.bounds.size.height);
        CGContextScaleCTM(ctx, 1.f, -1.f);
#endif
        CGContextTranslateCTM(ctx, -layer.bounds.origin.x, -layer.bounds.origin.y);
        [layer renderInContext:ctx];
    });
    
    if (completion)
        completion(result);
}

- (VMKImage*)loadTestImageForSelector:(SEL)selector {
    return [self loadTestImage:[self imageNameForSelector:selector]];
}

- (void)saveImage:(VMKImage*)data forSelector:(SEL)selector {
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

- (VMKImage*)loadTestImage:(NSString*)imageName {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
#if TARGET_OS_IPHONE
    NSString* fullName = [NSString stringWithFormat:@"%@%@", imageName, [self.class imageSuffix]];
    NSString* type = @"png";
#else
    NSString* fullName = [NSString stringWithFormat:@"%@", imageName];
    NSString* type = @"tiff";
#endif
    NSString* path = [bundle pathForResource:fullName ofType:type];
    VMKImage* image = [[VMKImage alloc] initWithContentsOfFile:path];

#if !TARGET_OS_IPHONE
    // Remove all image representation except for the current resolution
    NSImageRep* bestRep = [image beestRepresentationForScreenScale];
    for (NSImageRep* rep in image.representations)
        if (rep != bestRep)
            [image removeRepresentation:rep];
#endif

    return image;
}

- (void)saveImage:(VMKImage*)image withName:(NSString*)name {
    NSString* fullName = [NSString stringWithFormat:@"%@%@.png", name, [self.class imageSuffix]];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fullName];

#if TARGET_OS_IPHONE
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:YES];
#else
    CGImageRef cgRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];

    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    [pngData writeToFile:filePath atomically:YES];
#endif
}

+ (NSString*)imageSuffix {
    CGFloat scale = VMKScreenScale();
    if (scale != 1)
        return [NSString stringWithFormat:@"@%.0fx", scale];
    return @"";
}

- (void)overrideLayerBackgorunds:(CALayer *)layer dictionary:(NSDictionary *)dictionary {
    if (!layer)
        return;
    
    // Force render the base layer so the sublayers are created
    if (!layer.superlayer)
        [self renderLayer:layer completion:nil];

    VMKColor* color = dictionary[layer.class];
    if (color)
        layer.backgroundColor = [color colorWithAlphaComponent:0.3].CGColor;
    
    for (CALayer *sublayer in layer.sublayers) {
        [self overrideLayerBackgorunds:sublayer dictionary:dictionary];
    }
}

@end
