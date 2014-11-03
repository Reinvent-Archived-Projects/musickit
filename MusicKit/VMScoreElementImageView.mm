//  Created by Alejandro Isaza on 2014-04-03.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementImageView.h"
#import "VMImageStore.h"

@implementation VMScoreElementImageView

- (id)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry {
    self = [super initWithGeometry:geometry];
    self.imageName = imageName;
    return self;
}

- (id)initWithImage:(UIImage*)image geometry:(const mxml::Geometry*)geometry {
    self = [super initWithGeometry:geometry];
    self.image = image;
    return self;
}

- (void)setup {
    [super setup];
    _imageView = [[UIImageView alloc] init];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
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
        VMImageStore* imageStore = [VMImageStore sharedInstance];
        self.image = [imageStore imageNamed:self.imageName];
    } else {
        self.image = nil;
    }
}

- (UIImage*)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self sizeToFit];
    [self invalidateIntrinsicContentSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
