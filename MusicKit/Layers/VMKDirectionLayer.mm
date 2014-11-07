//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKDirectionLayer.h"


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
        _textLayer.font = (CFTypeRef)@"Baskerville-BoldItalic";
        _textLayer.fontSize = 26;
        _textLayer.string = [NSString stringWithUTF8String:dynamics->string().c_str()];
    }

    mxml::dom::Words* words = dynamic_cast<mxml::dom::Words*>(direction.type());
    if (words) {
        _textLayer.font = (CFTypeRef)@"Baskerville-SemiBold";
        _textLayer.fontSize = 20;
        _textLayer.string = [NSString stringWithUTF8String:words->contents().c_str()];
    }
}

- (void)layoutSublayers {
    CGSize size = self.bounds.size;
    _textLayer.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
