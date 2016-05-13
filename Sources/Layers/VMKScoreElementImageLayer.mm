// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    [super setActiveForegroundColor:foregroundColor];
    [self _updateImage];
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    [super setInactiveForegroundColor:foregroundColor];
    [self _updateImage];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
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
