//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKImageStore.h"

@interface VMKImageStore ()
@property(nonatomic, strong) NSMutableDictionary* images;
@end

@implementation VMKImageStore

+ (instancetype)sharedInstance {
    static VMKImageStore* imageStoreInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageStoreInstance = [[VMKImageStore alloc] init];
    });
    return imageStoreInstance;
}

- (id)init {
    self = [super init];
    self.images = [[NSMutableDictionary alloc] init];
    self.foregroundColor = [VMKColor blackColor];
    return self;
}

- (void)setForegroundColor:(VMKColor*)foregroundColor {
    _foregroundColor = foregroundColor;
    [self.images removeAllObjects];
}

- (VMKImage*)imageNamed:(NSString*)name {
    VMKImage* image = self.images[name];
    if (image)
        return image;

    image = [self.class maskFillImage:[VMKImage imageNamed:name] withColor:self.foregroundColor];
    if (image)
        self.images[name] = image;

    return image;
}

+ (VMKImage*)maskFillImage:(VMKImage*)image withColor:(VMKColor*)color {
    CGSize size = image.size;
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);

#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextClipToMask(context, bounds, image.CGImage);

    [color setFill];
    UIRectFill(bounds);

    VMKImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#else
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
    CGContextTranslateCTM(ctx, 0, size.height);
    CGContextScaleCTM(ctx, 1.f, -1.f);
    CGContextClipToMask(ctx, bounds, cgimage);

    [color setFill];
    CGContextFillRect(ctx, bounds);

    [result unlockFocus];
#endif

    return result;
}

@end
