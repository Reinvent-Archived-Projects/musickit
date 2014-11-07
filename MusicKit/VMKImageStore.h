//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKColor.h"
#import "VMKImage.h"


/**
 VMKImageStore keeps a cache of images with a specific foreground color. When the foreground color changes the cache is reset.
 */
@interface VMKImageStore : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong) VMKColor* foregroundColor;

- (VMKImage*)imageNamed:(NSString*)name;
+ (VMKImage*)maskFillImage:(VMKImage*)image withColor:(VMKColor*)color;

@end
