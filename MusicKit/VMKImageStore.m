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
    if (image == nil)
        return nil;
    
    CGSize size = image.size;
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);

#if TARGET_OS_IPHONE
    return VMKRenderImage(size, ^(CGContextRef ctx) {
        CGContextTranslateCTM(ctx, 0, size.height);
        CGContextScaleCTM(ctx, 1.f, -1.f);
        CGContextClipToMask(ctx, bounds, image.CGImage);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, bounds);
    });
#else
    return VMKRenderImage(size, ^(CGContextRef ctx) {
        CGImageRef cgimage = [image CGImageForProposedRect:nil context:nil hints:nil];
        CGContextTranslateCTM(ctx, 0, size.height);
        CGContextScaleCTM(ctx, 1.f, -1.f);
        CGContextClipToMask(ctx, bounds, cgimage);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, bounds);
    });
#endif
}

@end
