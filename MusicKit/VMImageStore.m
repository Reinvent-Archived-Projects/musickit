//  Created by Alejandro Isaza on 2014-06-10.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMImageStore.h"

@interface VMImageStore ()
@property(nonatomic, strong) NSMutableDictionary* images;
@end

@implementation VMImageStore

+ (instancetype)sharedInstance {
    static VMImageStore* imageStoreInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageStoreInstance = [[VMImageStore alloc] init];
    });
    return imageStoreInstance;
}

- (id)init {
    self = [super init];
    self.images = [[NSMutableDictionary alloc] init];
    self.foregroundColor = [UIColor blackColor];
    return self;
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    [self.images removeAllObjects];
}

- (UIImage*)imageNamed:(NSString*)name {
    UIImage* image = self.images[name];
    if (image)
        return image;

    image = [self.class maskFillImage:[UIImage imageNamed:name] withColor:self.foregroundColor];
    if (image)
        self.images[name] = image;

    return image;
}

+ (UIImage*)maskFillImage:(UIImage*)image withColor:(UIColor*)color {
    CGSize size = image.size;
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextClipToMask(context, bounds, image.CGImage);

    [color setFill];
    UIRectFill(bounds);

    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

@end
