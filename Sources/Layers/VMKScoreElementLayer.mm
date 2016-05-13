// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#import "VMKColor.h"
#import "VMKGeometry.h"
#import "VMKImage.h"


@implementation VMKScoreElementLayer

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self setup];
    return self;
}

- (instancetype)initWithGeometry:(const mxml::Geometry*)geometry {
    self = [self init];
    self.geometry = geometry;
    return self;
}

- (void)setup {
    self.backgroundColor = [VMKColor clearColor].CGColor;
    self.activeForegroundColor = [VMKColor blackColor];
    self.inactiveForegroundColor = [VMKColor lightGrayColor];
    self.opaque = NO;
    self.contentsScale = VMKScreenScale();
}

- (id<CAAction>)actionForKey:(NSString *)event {
    // Disable implicit animations
    return nil;
}

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    if (_activeForegroundColor == foregroundColor)
        return;

    _activeForegroundColor = foregroundColor;
    [self setNeedsDisplay];
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    if (_inactiveForegroundColor == foregroundColor)
        return;

    _inactiveForegroundColor = foregroundColor;
    [self setNeedsDisplay];
}

- (VMKColor*)foregroundColor {
    if (_geometry && _geometry->isActive())
        return self.activeForegroundColor;
    return self.inactiveForegroundColor;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    if (geometry == _geometry)
        return;

    _geometry = geometry;
    if (!_geometry) {
        self.bounds = CGRectZero;
        return;
    }

    CGRect bounds = VMKRoundRect(CGRectFromRect(_geometry->bounds()));
    self.bounds = bounds;

    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    if (bounds.size.width > 0 && bounds.size.height > 0) {
        anchorPoint = CGPointMake(_geometry->anchorPoint().x / bounds.size.width,
                                  _geometry->anchorPoint().y / bounds.size.height);
    }
    self.anchorPoint = anchorPoint;

    self.position = CGPointFromPoint(_geometry->location());
    self.frame = VMKRoundRect(self.frame);
}

- (CGSize)preferredFrameSize {
    if (_geometry)
        return CGSizeFromSize(_geometry->size());
    return [super preferredFrameSize];
}

- (void)display {
    // Rendering with a size of 0 crashes on OSX, we should look mxml lib
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return;
    }
    
    if (![self respondsToSelector:@selector(drawInContext:)])
        [super display];

    VMKImage* image = VMKRenderImage(self.bounds.size, ^(CGContextRef ctx) {
        CGContextTranslateCTM(ctx, -self.bounds.origin.x, -self.bounds.origin.y);
        [self drawInContext:ctx];
    });

#if TARGET_OS_IPHONE
    self.contents = (id)image.CGImage;
#else
    self.contents = image;
#endif
}

@end
