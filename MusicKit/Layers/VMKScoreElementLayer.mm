//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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

- (void)dealloc {
    CGColorRelease(_foregroundColor);
}

- (void)setup {
    self.backgroundColor = [VMKColor clearColor].CGColor;
    self.foregroundColor = [VMKColor blackColor].CGColor;
    self.opaque = NO;
    self.contentsScale = VMKScreenScale();
}

- (id<CAAction>)actionForKey:(NSString *)event {
    // Disable implicit animations
    return nil;
}

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    if (_foregroundColor == foregroundColor)
        return;

    CGColorRelease(_foregroundColor);
    _foregroundColor = foregroundColor;
    CGColorRetain(_foregroundColor);

    [self setNeedsDisplay];
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    if (geometry == _geometry)
        return;

    _geometry = geometry;
    if (!_geometry) {
        self.bounds = CGRectZero;
        return;
    }

    CGSize size = CGSizeFromSize(_geometry->size());

    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    if (size.width > 0 && size.height > 0) {
        anchorPoint = CGPointMake(_geometry->anchorPoint().x / size.width,
                                  _geometry->anchorPoint().y / size.height);
    }
    self.anchorPoint = anchorPoint;

    self.bounds = {CGPointFromPoint(_geometry->contentOffset()), size};
    self.position = CGPointFromPoint(_geometry->location());
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
