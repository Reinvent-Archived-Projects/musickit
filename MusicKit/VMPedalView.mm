//  Created by Alejandro Isaza on 2014-06-16.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMDrawing.h"
#import "VMImageStore.h"
#import "VMPedalView.h"
#include "Pedal.h"

using namespace mxml;


@implementation VMPedalView

- (id)initWithSpanDirectionGeometry:(const SpanDirectionGeometry*)wedgeGeom {
    return [super initWithGeometry:wedgeGeom];
}

- (const SpanDirectionGeometry*)spanDirectionGeometry {
    return static_cast<const SpanDirectionGeometry*>(self.geometry);
}

- (void)setSpanDirectionGeometry:(const SpanDirectionGeometry*)spanDirectionGeometry {
    self.geometry = spanDirectionGeometry;
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [super setForegroundColor:foregroundColor];
    [self setNeedsDisplay];
}

- (void)setGeometry:(const Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    const CGFloat lineWidth = SpanDirectionGeometry::kLineWidth;

    [self.foregroundColor setStroke];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, lineWidth);

    const SpanDirectionGeometry* geom = self.spanDirectionGeometry;
    const dom::Pedal& startPedal = dynamic_cast<const dom::Pedal&>(*geom->startDirection().type());
    //const dom::Pedal& stopPedal = dynamic_cast<const dom::Pedal&>(*geom->stopDirection().type());

    CGFloat width = geom->stopLocation().x - geom->startLocation().x;
    UIImage* pedImage = [[VMImageStore sharedInstance] imageNamed:@"ped"];
    [pedImage drawAtPoint:CGPointZero];

    if (startPedal.line()) {
        CGContextMoveToPoint(ctx, pedImage.size.width, pedImage.size.height - lineWidth-2);
        CGContextAddLineToPoint(ctx, width - lineWidth/2, pedImage.size.height - lineWidth-2);
        CGContextAddLineToPoint(ctx, width - lineWidth/2, pedImage.size.height/2);
    }

    if (startPedal.sign()) {
        UIImage* starImage = [[VMImageStore sharedInstance] imageNamed:@"star"];
        CGPoint point = CGPointMake(self.bounds.size.width - starImage.size.width, 0);
        [starImage drawAtPoint:point];
    }

    CGContextStrokePath(ctx);
}

@end
