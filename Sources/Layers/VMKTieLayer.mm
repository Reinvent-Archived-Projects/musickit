// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKColor.h"
#import "VMKTieLayer.h"
#include <cmath>

using namespace mxml;

static const CGFloat kMiddleStrokeWidth = 2;
static const CGFloat kEndPointWidth = 0.5;
static const CGFloat kTopControlsOutterX = 0.1925;
static const CGFloat kTopControlsInnerX = 0.1675;
static const CGFloat kEndsControlsY = 0.8;
static const CGFloat kEndsControlsOutterX = 0.0286;


@implementation VMKTieLayer

- (instancetype)initWithTieGeometry:(const mxml::TieGeometry*)tieGeom {
    return [super initWithGeometry:tieGeom];
}

- (const TieGeometry*)tieGeometry {
    return static_cast<const TieGeometry*>(self.geometry);
}

- (void)setTieGeometry:(const TieGeometry*)geom {
    [self setGeometry:geom];
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);

    const CGFloat dx = self.tieGeometry->stopLocation().x - self.tieGeometry->startLocation().x;
    const CGFloat dy = self.tieGeometry->stopLocation().y - self.tieGeometry->startLocation().y;
    const CGFloat angle = std::atan2(dy, dx);
    CGFloat curveLength = std::sqrt(dx*dx + dy*dy) + kEndPointWidth;
    CGFloat curveHeight = std::min((CGFloat)TieGeometry::kMaxHeight, std::sqrt(curveLength));

    const CGFloat EndsControlsInnerX = kEndPointWidth + 0.06 * curveLength;
    const CGPoint points[] = {
        // Start point
        {0.5f * curveLength, 0},

        // Top left bezier curve
        {kTopControlsOutterX * curveLength, 0},
        {kEndsControlsOutterX * curveLength, kEndsControlsY * curveHeight},
        {0, curveHeight},

        // Left endpoint line
        {kEndPointWidth, curveHeight},

        // Bottom left bezier curve
        {EndsControlsInnerX, kEndsControlsY * curveHeight},
        {kTopControlsInnerX * curveLength, kMiddleStrokeWidth},
        {0.5f * curveLength, kMiddleStrokeWidth},

        // Bottom right bezier curve
        {(1-kTopControlsInnerX) * curveLength, kMiddleStrokeWidth},
        {curveLength - EndsControlsInnerX, kEndsControlsY * curveHeight},
        {curveLength - kEndPointWidth, curveHeight},

        // Right endpoint line
        {curveLength, curveHeight},

        // Top right bezier curve
        {(1-kEndsControlsOutterX) * curveLength, kEndsControlsY * curveHeight},
        {(1-kTopControlsOutterX) * curveLength, 0},
        {0.5f * curveLength, 0}
    };


    CGContextSaveGState(ctx);

    CGRect bounds = CGRectMake(0, 0, curveLength, curveHeight);
    bounds = CGRectApplyAffineTransform(bounds, CGAffineTransformMakeRotation(angle));
    CGContextTranslateCTM(ctx, -bounds.origin.x, -bounds.origin.y);
    CGContextRotateCTM(ctx, angle);

    if (self.tieGeometry->placement().value() == mxml::dom::Placement::Below) {
        CGContextTranslateCTM(ctx, 0, curveHeight/2);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -curveHeight/2);
    }

    CGContextMoveToPoint(ctx, points[0].x, points[0].y);
    CGContextAddCurveToPoint(ctx, points[1].x, points[1].y, points[2].x, points[2].y, points[3].x, points[3].y);
    CGContextAddLineToPoint(ctx, points[4].x, points[4].y);
    CGContextAddCurveToPoint(ctx, points[5].x, points[5].y, points[6].x, points[6].y, points[7].x, points[7].y);
    CGContextAddCurveToPoint(ctx, points[8].x, points[8].y, points[9].x, points[9].y, points[10].x, points[10].y);
    CGContextAddLineToPoint(ctx, points[11].x, points[11].y);
    CGContextAddCurveToPoint(ctx, points[12].x, points[12].y, points[13].x, points[13].y, points[14].x, points[14].y);
    CGContextFillPath(ctx);

    if (self.drawControlPoints) {
        [[VMKColor redColor] setFill];
        for (int i = 0; i < sizeof(points) / sizeof(CGPoint); i += 1) {
            CGContextFillEllipseInRect(ctx, CGRectMake(points[i].x-1, points[i].y-1, 2, 2));
        }

        CGContextRestoreGState(ctx);
        [[VMKColor blueColor] setFill];
        CGContextFillEllipseInRect(ctx, CGRectMake(self.anchorPoint.x*self.bounds.size.width-2, self.anchorPoint.y*self.bounds.size.height-2, 4, 4));
    }
}

@end
