// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKBarlineLayer.h"
#import "VMKImageStore.h"
#import "VMKMeasureLayer.h"

#import <mxml/Metrics.h>


using namespace mxml;

static const CGFloat kLightLineWidth = 1;
static const CGFloat kHeavyLineWidth = 2;
static const CGFloat kLineSpacing = 2;


@implementation VMKBarlineLayer

- (instancetype)initWithBarlineGeometry:(const mxml::BarlineGeometry*)barlineGeom {
    return [super initWithGeometry:barlineGeom];
}

- (const mxml::BarlineGeometry*)barlineGeometry {
    return static_cast<const mxml::BarlineGeometry*>(self.geometry);
}

- (void)setBarlineGeometry:(const mxml::BarlineGeometry*)barlineGeometry {
    self.geometry = barlineGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geom {
    [super setGeometry:geom];

    CGRect bounds = self.bounds;
    bounds.size.height += VMKStaffLineWidth;
    self.bounds = bounds;
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    if (!self.geometry)
        return;

    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);
    if (self.barlineGeometry->barline().repeat()) {
        [self drawRepeatInContext:ctx];
    } else {
        [self drawRegularInContext:ctx];
    }
}

- (void)drawRegularInContext:(CGContextRef)ctx {
    using mxml::dom::Barline;

    CGFloat height = self.bounds.size.height;

    const BarlineGeometry* barlineGeom = static_cast<const BarlineGeometry*>(self.geometry);
    switch (barlineGeom->barline().style()) {
        case Barline::Style::Regular:
        case Barline::Style::Tick:
        case Barline::Style::Short:
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
            break;

        case Barline::Style::Dotted: {
            CGFloat lengths[] = {1, 2};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
        } break;

        case Barline::Style::Dashed: {
            CGFloat lengths[] = {2, 2};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
        } break;

        case Barline::Style::Heavy:
            CGContextFillRect(ctx, CGRectMake(0, 0, kHeavyLineWidth, height));
            break;

        case Barline::Style::LightLight:
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kLightLineWidth + kLineSpacing), 0, kLightLineWidth, height));
            break;

        case Barline::Style::LightHeavy:
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kLightLineWidth + kLineSpacing), 0, kHeavyLineWidth, height));
            break;

        case Barline::Style::HeavyLight:
            CGContextFillRect(ctx, CGRectMake(0, 0, kHeavyLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kHeavyLineWidth + kLineSpacing), 0, kLightLineWidth, height));
            break;

        case Barline::Style::HeavyHeavy:
            CGContextFillRect(ctx, CGRectMake(0, 0, kHeavyLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kHeavyLineWidth + kLineSpacing), 0, kHeavyLineWidth, height));
            break;

        case Barline::Style::None:
            break;
    }
}

- (void)drawRepeatInContext:(CGContextRef)ctx {
    CGFloat height = self.bounds.size.height;

    VMKImage* dotImage = [[VMKImageStore sharedInstance] imageNamed:@"dot" withColor:self.foregroundColor];
    CGSize dotSize = dotImage.size;
    CGFloat offset = 0;

    const BarlineGeometry* barlineGeom = self.barlineGeometry;
    const auto& repeat = barlineGeom->barline().repeat();
    if (repeat->direction() == dom::Repeat::Direction::Forward) {
        CGContextFillRect(ctx, CGRectMake(offset, 0, kHeavyLineWidth, height));
        offset += (kHeavyLineWidth + kLineSpacing);
        CGContextFillRect(ctx, CGRectMake(offset, 0, kLightLineWidth, height));
        offset += (kLightLineWidth + kLineSpacing);
    } else {
        offset = dotSize.width + kLineSpacing;
        CGContextFillRect(ctx, CGRectMake(offset, 0, kLightLineWidth, height));
        offset += (kLightLineWidth + kLineSpacing);
        CGContextFillRect(ctx, CGRectMake(offset, 0, kHeavyLineWidth, height));
        offset = 0;
    }

    auto& metrics = self.barlineGeometry->metrics();
    auto origin = self.geometry->origin();
    const auto staves = metrics.staves();
    for (int staff = 1; staff <= staves; staff += 1) {
        CGFloat y1 = (metrics.staffOrigin(staff) + mxml::Metrics::kStaffLineSpacing * 1.5 - origin.y);
        CGFloat y2 = (metrics.staffOrigin(staff) + mxml::Metrics::kStaffLineSpacing * 2.5 - origin.y);
        [dotImage drawInRect:CGRectMake(offset, y1 - dotSize.height/2, dotSize.width, dotSize.height)];
        [dotImage drawInRect:CGRectMake(offset, y2 - dotSize.height/2, dotSize.width, dotSize.height)];
    }
}

@end
