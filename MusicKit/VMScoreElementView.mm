 //  Created by Alejandro Isaza on 2014-03-31.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#import "VMDrawing.h"

@implementation VMScoreElementView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self setup];
    return self;
}

- (id)initWithGeometry:(const mxml::Geometry*)geometry {
    self = [super initWithFrame:CGRectZero];
    [self setup];
    self.geometry = geometry;
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.foregroundColor = [UIColor blackColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    if (_foregroundColor != foregroundColor) {
        _foregroundColor = foregroundColor;
        [self setNeedsDisplay];
    }
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    if (geometry == _geometry)
        return;

    _geometry = geometry;
    [self updateView];
}

- (void)updateView {
    if (!_geometry)
        return;

    CGSize size = CGSizeFromSize(_geometry->size());

    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    if (size.width > 0 && size.height > 0) {
        anchorPoint = CGPointMake(_geometry->anchorPoint().x / size.width,
                                  _geometry->anchorPoint().y / size.height);
    }
    self.layer.anchorPoint = anchorPoint;

    self.bounds = {CGPointFromPoint(_geometry->contentOffset()), size};
    self.center = CGPointFromPoint(_geometry->location());

    [self invalidateIntrinsicContentSize];
}

- (CGPoint)location {
    if (!_geometry)
        return CGPointZero;
    return CGPointFromPoint(_geometry->location());
}

- (CGPoint)anchorPoint {
    return self.layer.anchorPoint;
}

- (CGPoint)geometryOrigin {
    if (!_geometry)
        return CGPointZero;
    return CGPointFromPoint(_geometry->frame().origin);
}

- (CGSize)geometrySize {
    if (!_geometry)
        return CGSizeZero;
    return CGSizeFromSize(_geometry->size());
}

- (CGRect)geometryFrame {
    if (!_geometry)
        return CGRectZero;
    return CGRectFromRect(_geometry->frame());
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self geometrySize];
}

- (CGSize)intrinsicContentSize {
    return [self geometrySize];
}

@end
