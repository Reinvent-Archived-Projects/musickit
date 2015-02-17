//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKColor.h"
#import "VMKImage.h"


/**
 VMKImageStore keeps a cache of images with a specific foreground color. When the foreground color changes the cache is reset.
 */
@interface VMKImageStore : NSObject

+ (instancetype)sharedInstance;

- (VMKImage*)imageNamed:(NSString*)name withColor:(VMKColor*)color;
+ (VMKImage*)maskFillImage:(VMKImage*)image withColor:(VMKColor*)color;

- (void)removeCachedImagesWithColor:(VMKColor*)color;
- (void)removeAllCachedImages;

@end
