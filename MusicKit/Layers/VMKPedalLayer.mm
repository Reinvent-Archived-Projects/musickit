//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKGeometry.h"
#import "VMKImageStore.h"
#import "VMKPedalLayer.h"

#include <mxml/dom/Pedal.h>

using namespace mxml;


@implementation VMKPedalLayer

- (instancetype)initWithSpanDirectionGeometry:(const SpanDirectionGeometry*)wedgeGeom {
    return [super initWithGeometry:wedgeGeom];
}

- (const SpanDirectionGeometry*)spanDirectionGeometry {
    return static_cast<const SpanDirectionGeometry*>(self.geometry);
}

- (void)setSpanDirectionGeometry:(const SpanDirectionGeometry*)spanDirectionGeometry {
    self.geometry = spanDirectionGeometry;
}

- (void)setForegroundColor:(VMKColor*)foregroundColor {
    [super setForegroundColor:foregroundColor];
    [self setNeedsDisplay];
}

- (void)setGeometry:(const Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    const CGFloat lineWidth = SpanDirectionGeometry::kLineWidth;

    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor.CGColor);
    CGContextSetLineWidth(ctx, lineWidth);

    const SpanDirectionGeometry* geom = self.spanDirectionGeometry;
    const dom::Pedal& startPedal = dynamic_cast<const dom::Pedal&>(*geom->startDirection().type());
    //const dom::Pedal& stopPedal = dynamic_cast<const dom::Pedal&>(*geom->stopDirection().type());

    CGFloat width = geom->stopLocation().x - geom->startLocation().x;
    VMKImage* pedImage = [[VMKImageStore sharedInstance] imageNamed:@"ped" withColor:self.foregroundColor];
    [pedImage drawInRect:CGRectMake(0, 0, pedImage.size.width, pedImage.size.height)];

    if (startPedal.line()) {
        CGContextMoveToPoint(ctx, pedImage.size.width, pedImage.size.height - lineWidth-2);
        CGContextAddLineToPoint(ctx, width - lineWidth/2, pedImage.size.height - lineWidth-2);
        CGContextAddLineToPoint(ctx, width - lineWidth/2, pedImage.size.height/2);
    }

    if (startPedal.sign()) {
        VMKImage* starImage = [[VMKImageStore sharedInstance] imageNamed:@"star" withColor:self.foregroundColor];
        CGPoint point = CGPointMake(self.bounds.size.width - starImage.size.width, 0);
        [starImage drawInRect:CGRectMake(point.x, point.y, starImage.size.width, starImage.size.height)];
    }

    CGContextStrokePath(ctx);
}

@end
