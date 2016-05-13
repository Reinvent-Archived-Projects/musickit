// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKImageStore.h"

@interface VMKImageStore ()

@property(nonatomic, strong) NSMutableDictionary* imagesByColor;
@property(nonatomic, strong) dispatch_queue_t queue;

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
    self.imagesByColor = [[NSMutableDictionary alloc] init];
    self.queue = dispatch_queue_create("VMKImageStore", DISPATCH_QUEUE_SERIAL);
    return self;
}

- (VMKImage*)imageNamed:(NSString*)name withColor:(VMKColor*)color {
    __block NSMutableDictionary* images;

    dispatch_sync(_queue, ^{
        images = self.imagesByColor[color];
        if (!images) {
            images = [NSMutableDictionary dictionary];
            self.imagesByColor[color] = images;
        }
    });

    VMKImage* image = images[name];
    if (image)
        return image;

    image = [self.class maskFillImage:[VMKImage imageNamed:name] withColor:color];
    if (image)
        images[name] = image;

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

- (void)removeCachedImagesWithColor:(VMKColor*)color {
    dispatch_async(_queue, ^{
        [self.imagesByColor removeObjectForKey:color];
    });
}

- (void)removeAllCachedImages {
    dispatch_async(_queue, ^{
        [self.imagesByColor removeAllObjects];
    });
}

@end
