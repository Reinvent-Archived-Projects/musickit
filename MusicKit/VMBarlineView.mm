//  Created by Alejandro Isaza on 2014-05-01.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMBarlineView.h"
#import "VMImageStore.h"

using namespace mxml;

static const CGFloat kLightLineWidth = 1;
static const CGFloat kHeavyLineWidth = 2;
static const CGFloat kLineSpacing = 2;


@implementation VMBarlineView {
    const dom::Part* _part;
}

- (id)initWithBarlineGeometry:(const mxml::BarlineGeometry*)barlineGeom {
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
    
    if (geom) {
        auto barlineGeom = self.barlineGeometry;
        auto barline = barlineGeom->barline();
        
        const dom::Measure* measure = dynamic_cast<const dom::Measure*>(barline.parent());
        assert(measure);
        
        _part = dynamic_cast<const dom::Part*>(measure->parent());
        assert(_part);
    }

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.geometry)
        return;

    [self.foregroundColor setFill];
    if (self.barlineGeometry->barline().repeat().isPresent()) {
        [self drawRepeat];
    } else {
        [self drawRegular];
    }
}

- (void)drawRegular {
    using mxml::dom::Barline;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat height = self.bounds.size.height;
    
    const BarlineGeometry* barlineGeom = static_cast<const BarlineGeometry*>(self.geometry);
    switch (barlineGeom->barline().style()) {
        case Barline::REGULAR:
        case Barline::TICK:
        case Barline::SHORT:
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
            break;
            
        case Barline::DOTTED: {
            CGFloat lengths[] = {1, 2};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
        } break;
            
        case Barline::DASHED: {
            CGFloat lengths[] = {2, 2};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
        } break;
            
        case Barline::HEAVY:
            CGContextFillRect(ctx, CGRectMake(0, 0, kHeavyLineWidth, height));
            break;
            
        case Barline::LIGHT_LIGHT:
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kLightLineWidth + kLineSpacing), 0, kLightLineWidth, height));
            break;
            
        case Barline::LIGHT_HEAVY:
            CGContextFillRect(ctx, CGRectMake(0, 0, kLightLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kLightLineWidth + kLineSpacing), 0, kHeavyLineWidth, height));
            break;
            
        case Barline::HEAVY_LIGHT:
            CGContextFillRect(ctx, CGRectMake(0, 0, kHeavyLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kHeavyLineWidth + kLineSpacing), 0, kLightLineWidth, height));
            break;
            
        case Barline::HEAVY_HEAVY:
            CGContextFillRect(ctx, CGRectMake(0, 0, kHeavyLineWidth, height));
            CGContextFillRect(ctx, CGRectMake((kHeavyLineWidth + kLineSpacing), 0, kHeavyLineWidth, height));
            break;
            
        case Barline::NONE:
            break;
    }
}

- (void)drawRepeat {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat height = self.bounds.size.height;
    
    UIImage* dotImage = [[VMImageStore sharedInstance] imageNamed:@"dot"];
    CGSize dotSize = dotImage.size;
    CGFloat offset = 0;
    
    const BarlineGeometry* barlineGeom = self.barlineGeometry;
    const dom::Repeat& repeat = barlineGeom->barline().repeat();
    if (repeat.direction() == dom::Repeat::DIRECTION_FORWARD) {
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
    
    for (int staff = 1; staff <= _part->staves(); staff += 1) {
        CGFloat y1 = (barlineGeom->partGeometry().staffOrigin(staff) + mxml::PartGeometry::kStaffLineSpacing * 1.5 - self.geometryOrigin.y);
        CGFloat y2 = (barlineGeom->partGeometry().staffOrigin(staff) + mxml::PartGeometry::kStaffLineSpacing * 2.5 - self.geometryOrigin.y);
        [dotImage drawInRect:CGRectMake(offset, y1 - dotSize.height/2, dotSize.width, dotSize.height)];
        [dotImage drawInRect:CGRectMake(offset, y2 - dotSize.height/2, dotSize.width, dotSize.height)];
    }
}

@end
