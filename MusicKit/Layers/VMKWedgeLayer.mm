//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKWedgeLayer.h"
#include <mxml/dom/Wedge.h>

using namespace mxml;


@implementation VMKWedgeLayer

- (id)initWithSpanDirectionGeometry:(const SpanDirectionGeometry*)wedgeGeom {
    return [super initWithGeometry:wedgeGeom];
}

- (const SpanDirectionGeometry*)spanDirectionGeometry {
    return static_cast<const SpanDirectionGeometry*>(self.geometry);
}

- (void)setSpanDirectionGeometry:(const SpanDirectionGeometry*)spanDirectionGeometry {
    self.geometry = spanDirectionGeometry;
}

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    [super setForegroundColor:foregroundColor];
    [self setNeedsDisplay];
}

- (void)setGeometry:(const Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    const CGFloat lineWidth = SpanDirectionGeometry::kLineWidth;

    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextTranslateCTM(ctx, 0, lineWidth/2);

    const SpanDirectionGeometry* geom = self.spanDirectionGeometry;
    const dom::Wedge& startWedge = dynamic_cast<const dom::Wedge&>(*geom->startDirection().type());
    const dom::Wedge& stopWedge = dynamic_cast<const dom::Wedge&>(*geom->stopDirection().type());

    CGFloat width = geom->stopLocation().x - geom->startLocation().x;

    if (startWedge.type() == dom::Wedge::kTypeCrescendo) {
        CGFloat spread = stopWedge.spread();
        CGContextMoveToPoint(ctx, width, 0);
        CGContextAddLineToPoint(ctx, 0, spread/2);
        CGContextAddLineToPoint(ctx, width, spread);
    } else if (startWedge.type() == dom::Wedge::kTypeDiminuendo) {
        CGFloat spread = startWedge.spread();
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, width, spread/2);
        CGContextAddLineToPoint(ctx, 0, spread);
    }

    CGContextStrokePath(ctx);
}

@end
