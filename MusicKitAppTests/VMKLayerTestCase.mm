// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKGeometry.h"
#import "VMKLayerTestCase.h"
#import "VMKImageStore.h"

const CGFloat kMaximumError = 0.2f;

static NSString* const CLASS_PREFIX = @"VMK";
static NSString* const CLASS_SUFFIX = @"Tests";
static NSString* const TEST_PREFIX = @"test";

@implementation VMKLayerTestCase

+ (void)load {
    // Print the location of temporary directory for reference
    NSLog(@"Image test results written to\n%@", NSTemporaryDirectory());
}

- (void)calculateRenderingErrors:(CALayer*)layer forSelector:(SEL)selector testBlock:(void (^)(VMKRenderingErrors))testBlock {
    NSString *imageName = [self imageNameForSelector:selector];

    BOOL __block timedOut = NO;
    XCTestExpectation* expectation = [self expectationWithDescription:@"renderView"];

    VMKImage* expected = [self loadTestImageWithName:imageName];
    [self renderLayer:layer completion:^(VMKImage* rendered) {
        if (timedOut)
            return;

        [expectation fulfill];

        if (rendered.size.width != expected.size.width || rendered.size.height != expected.size.height) {
            [self saveImage:rendered name:imageName];
            XCTFail(@"View should match size of reference image");
            return;
        }

        AIComponents components = AIImageMeanAbsoluteErrorByComponent(rendered, expected);

        VMKRenderingErrors errors;
        errors.maximumError = AIImageMaximumAbsoluteError(rendered, expected);;
        errors.colorError = components.red + components.green + components.blue;
        errors.alphaError = components.alpha;
        errors.rms = AIImageRootMeanSquareError(rendered, expected);
        errors.ratio = AIImageDifferentPixelRatio(rendered, expected);
        testBlock(errors);

        [self saveImage:rendered name:imageName];
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

- (VMKImage*)loadTestImageWithName:(NSString *)name {
    return [self loadTestImage:name];
}

- (void)saveImage:(VMKImage*)data name:(NSString *)name {
    [self saveImage:data withName:name];
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
