// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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

- (void)setGeometry:(const Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    const CGFloat lineWidth = SpanDirectionGeometry::kLineWidth;

    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor.CGColor);
    CGContextSetLineWidth(ctx, lineWidth);

    const SpanDirectionGeometry* geom = self.spanDirectionGeometry;
    const dom::Pedal& pedal = dynamic_cast<const dom::Pedal&>(*geom->type());

    CGFloat width = geom->stopLocation().x - geom->startLocation().x;
    VMKImage* pedImage = [[VMKImageStore sharedInstance] imageNamed:@"ped" withColor:self.foregroundColor];
    [pedImage drawInRect:CGRectMake(0, 0, pedImage.size.width, pedImage.size.height)];

    if (pedal.line()) {
        CGContextMoveToPoint(ctx, pedImage.size.width, pedImage.size.height - lineWidth-2);
        CGContextAddLineToPoint(ctx, width - lineWidth/2, pedImage.size.height - lineWidth-2);
        if (geom->stopDirection())
            CGContextAddLineToPoint(ctx, width - lineWidth/2, pedImage.size.height/2);
    }

    if (pedal.sign()) {
        VMKImage* starImage = [[VMKImageStore sharedInstance] imageNamed:@"star" withColor:self.foregroundColor];
        CGPoint point = CGPointMake(self.bounds.size.width - starImage.size.width, 0);
        [starImage drawInRect:CGRectMake(point.x, point.y, starImage.size.width, starImage.size.height)];
    }

    CGContextStrokePath(ctx);
}

@end
