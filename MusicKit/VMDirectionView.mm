//  Created by Alejandro Isaza on 2014-04-17.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMDirectionView.h"

using namespace mxml::dom;

@implementation VMDirectionView

- (id)initWithDirectionGeometry:(const mxml::DirectionGeometry*)directionGeom {
    return [super initWithGeometry:directionGeom];
}

- (void)setup {
    [super setup];
    
    _label = [[UILabel alloc] init];
    _label.textColor = self.foregroundColor;
    _label.backgroundColor = self.backgroundColor;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [super setForegroundColor:foregroundColor];
    _label.textColor = self.foregroundColor;
}

- (const mxml::DirectionGeometry*)directionGeometry {
    return static_cast<const mxml::DirectionGeometry*>(self.geometry);
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    
    const Direction& direction = self.directionGeometry->direction();
    
    Dynamics* dynamics = dynamic_cast<Dynamics*>(direction.type());
    if (dynamics) {
        _label.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:26];
        _label.text = [NSString stringWithUTF8String:dynamics->string().c_str()];
    }

    Words* words = dynamic_cast<Words*>(direction.type());
    if (words) {
        _label.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:20];
        _label.text = [NSString stringWithUTF8String:words->contents().c_str()];
    }
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    _label.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
