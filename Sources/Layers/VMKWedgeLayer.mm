// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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

- (void)setGeometry:(const Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    const CGFloat lineWidth = SpanDirectionGeometry::kLineWidth;

    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor.CGColor);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextTranslateCTM(ctx, 0, lineWidth/2);

    const SpanDirectionGeometry* geom = self.spanDirectionGeometry;
    const dom::Wedge& startWedge = dynamic_cast<const dom::Wedge&>(*geom->startDirection()->type());
    const dom::Wedge& stopWedge = dynamic_cast<const dom::Wedge&>(*geom->stopDirection()->type());

    CGFloat width = geom->stopLocation().x - geom->startLocation().x;

    if (startWedge.type() == dom::Wedge::Type::Crescendo) {
        CGFloat spread = stopWedge.spread();
        CGContextMoveToPoint(ctx, width, 0);
        CGContextAddLineToPoint(ctx, 0, spread/2);
        CGContextAddLineToPoint(ctx, width, spread);
    } else if (startWedge.type() == dom::Wedge::Type::Diminuendo) {
        CGFloat spread = startWedge.spread();
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, width, spread/2);
        CGContextAddLineToPoint(ctx, 0, spread);
    }

    CGContextStrokePath(ctx);
}

@end
