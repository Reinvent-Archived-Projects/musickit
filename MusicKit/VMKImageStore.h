// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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
