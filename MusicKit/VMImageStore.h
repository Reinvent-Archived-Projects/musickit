//  Created by Alejandro Isaza on 2014-06-10.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>

/**
 VMImageStore keeps a cache of images with a specific foreground color. When the foreground color changes the cache is reset.
 */
@interface VMImageStore : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong) UIColor* foregroundColor;

- (UIImage*)imageNamed:(NSString*)name;
+ (UIImage*)maskFillImage:(UIImage*)image withColor:(UIColor*)color;

@end
