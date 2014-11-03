//  Created by Alejandro Isaza on 2014-06-24.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMEndingView.h"
#import "VMDrawing.h"

@implementation VMEndingView

static const CGFloat kLineWidth = 1;

- (id)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeom {
    return [super initWithGeometry:endingGeom];
}

- (const mxml::EndingGeometry*)endingGeometry {
    return static_cast<const mxml::EndingGeometry*>(self.geometry);
}

- (void)setEndingGeometry:(const mxml::EndingGeometry *)endingGeometry {
    [self setGeometry:endingGeometry];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    const mxml::EndingGeometry* geom = self.endingGeometry;

    [self.foregroundColor setStroke];
    [self.foregroundColor setFill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGSize size = self.bounds.size;
    CGRect fillRect;
    fillRect.origin = CGPointZero;
    fillRect.size.width = kLineWidth;
    fillRect.size.height = size.height;
    CGContextFillRect(ctx, VMRoundRect(fillRect));

    fillRect.size.width = geom->size().width;
    fillRect.size.height = kLineWidth;
    CGContextFillRect(ctx, VMRoundRect(fillRect));

    if (geom->stopEnding().type() == mxml::dom::Ending::STOP) {
        fillRect.origin.x = size.width - kLineWidth;
        fillRect.size.width = kLineWidth;
        fillRect.size.height = size.height;
        CGContextFillRect(ctx, VMRoundRect(fillRect));
    }

    NSMutableString* string = [NSMutableString string];
    for (auto number : geom->stopEnding().numbers()) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendFormat:@"%d.", number];
    }

    NSDictionary* attribs = @{ NSFontAttributeName: [UIFont fontWithName:@"Baskerville" size:13] };
    [string drawAtPoint:CGPointMake(2*kLineWidth, kLineWidth) withAttributes:attribs];
}

@end
