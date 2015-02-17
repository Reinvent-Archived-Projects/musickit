//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#import "VMKImageStore.h"


@implementation VMKScoreElementImageLayer

- (instancetype)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry {
    self = [super initWithGeometry:geometry];
    self.imageName = imageName;
    return self;
}

- (instancetype)initWithImage:(VMKImage*)image geometry:(const mxml::Geometry*)geometry {
    self = [super initWithGeometry:geometry];
    self.image = image;
    return self;
}

- (void)setForegroundColor:(VMKColor*)foregroundColor {
    [super setForegroundColor:foregroundColor];
    [self _updateImage];
}

- (void)setImageName:(NSString *)imageName {
    if (imageName == _imageName)
        return;

    _imageName = imageName;
    [self _updateImage];
}

- (void)_updateImage {
    if (self.imageName) {
        VMKImageStore* imageStore = [VMKImageStore sharedInstance];
        self.image = [imageStore imageNamed:self.imageName withColor:self.foregroundColor];
    } else {
        self.image = nil;
    }
}

- (void)setImage:(VMKImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)display {
    if (!_image)
        self.contents = nil;
    
#if TARGET_OS_IPHONE
    self.contents = (id)_image.CGImage;
#else
    self.contents = _image;
#endif
}

@end
