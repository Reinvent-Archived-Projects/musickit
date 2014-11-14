//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKDirectionLayer.h"
#import "VMKGeometry.h"
#import "VMKColor.h"


@implementation VMKDirectionLayer

- (instancetype)initWithDirectionGeometry:(const mxml::DirectionGeometry*)directionGeom {
    return [super initWithGeometry:directionGeom];
}

- (void)setup {
    [super setup];

    _textLayer = [CATextLayer layer];
    _textLayer.foregroundColor = self.foregroundColor;
    _textLayer.backgroundColor = self.backgroundColor;
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.contentsScale = VMKScreenScale();
#if !TARGET_OS_IPHONE
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DTranslate(t, 0, -_textLayer.preferredFrameSize.height, 0);
    t = CATransform3DScale(t, 1, -1, 1);
    _textLayer.transform = t;
#endif
    [self addSublayer:_textLayer];
}

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    [super setForegroundColor:foregroundColor];
    _textLayer.foregroundColor = foregroundColor;
}

- (const mxml::DirectionGeometry*)directionGeometry {
    return static_cast<const mxml::DirectionGeometry*>(self.geometry);
}

- (void)setDirectionGeometry:(const mxml::DirectionGeometry*)directionGeometry {
    [self setGeometry:directionGeometry];
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];

    const mxml::dom::Direction& direction = self.directionGeometry->direction();

    mxml::dom::Dynamics* dynamics = dynamic_cast<mxml::dom::Dynamics*>(direction.type());
    if (dynamics) {
        _textLayer.font = CFSTR("Baskerville-BoldItalic");
        _textLayer.fontSize = 26;
        _textLayer.string = [NSString stringWithUTF8String:dynamics->string().c_str()];
    }

    mxml::dom::Words* words = dynamic_cast<mxml::dom::Words*>(direction.type());
    if (words) {
        _textLayer.font = CFSTR("Baskerville-SemiBold");
        _textLayer.fontSize = 20;
        _textLayer.string = [NSString stringWithUTF8String:words->contents().c_str()];
    }

    _textLayer.frame = {CGPointZero, self.bounds.size};
}

- (void)layoutSublayers {
    [super layoutSublayers];
    _textLayer.frame = {CGPointZero, self.bounds.size};
}

@end
