// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKGeometry.h"
#import "VMKImageStore.h"
#import "VMKOctaveShiftLayer.h"

#import <CoreText/CoreText.h>

#include <mxml/dom/OctaveShift.h>

static const CGFloat kLineWidth = 1;

using namespace mxml;


@implementation VMKOctaveShiftLayer

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

    CGFloat width = geom->stopLocation().x - geom->startLocation().x;

    
    CTFontRef font = CTFontCreateWithName(CFSTR("Baskerville-Italic"), 22.0, NULL);
    NSDictionary* attribs = @{ (id)kCTFontAttributeName: (__bridge id)font };
    NSMutableAttributedString* stringToDraw;
    if (!geom->isContinuation())
        stringToDraw = [[NSMutableAttributedString alloc] initWithString:@"8va" attributes:attribs];
    else
        stringToDraw = [[NSMutableAttributedString alloc] initWithString:@"(8va)" attributes:attribs];
    [stringToDraw addAttribute:(id)kCTSuperscriptAttributeName value:@1 range:NSMakeRange(1, 2) ];

    // Flip the context coordinates
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    // draw 
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextSetTextPosition(ctx, 0, 1);
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
    CGRect bounds = CTLineGetImageBounds(line, ctx);
    CTLineDraw(line, ctx);

    // clean up
    CFRelease(line);
    CFRelease(font);

    CGContextMoveToPoint(ctx, CGRectGetMaxX(bounds) + 2, CGRectGetMidY(bounds) - kLineWidth/2);
    CGContextAddLineToPoint(ctx, width - lineWidth/2, CGRectGetMidY(bounds) - kLineWidth/2);
    if (geom->stopDirection())
        CGContextAddLineToPoint(ctx, width - lineWidth/2, CGRectGetMinY(bounds));
    CGContextStrokePath(ctx);
}

@end
