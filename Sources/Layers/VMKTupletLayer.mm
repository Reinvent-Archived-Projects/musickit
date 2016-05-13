// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKTupletLayer.h"
#import "VMKGeometry.h"
#import <CoreText/CoreText.h>


@implementation VMKTupletLayer

- (instancetype)initWithTupletGeometry:(const mxml::TupletGeometry*)tupletGeometry {
    return [super initWithGeometry:tupletGeometry];
}

- (const mxml::TupletGeometry*)tupletGeometry {
    return static_cast<const mxml::TupletGeometry*>(self.geometry);
}

- (void)setTupletGeometry:(const mxml::TupletGeometry*)tupletGeometry {
    self.geometry = tupletGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    static const CGFloat kLineWidth = 1.0;

    CGContextSetFillColorWithColor(ctx, self.backgroundColor);
    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor.CGColor);

    auto geom = self.tupletGeometry;

    CTFontRef font = CTFontCreateWithName(CFSTR("Baskerville"), 13.0, NULL);
    NSDictionary* attribs = @{ (id)kCTFontAttributeName: (__bridge id)font };
    NSString* stringToDraw = [NSString stringWithFormat:@"%d", geom->displayNumber()];
    NSMutableAttributedString* attributedStringToDraw = [[NSMutableAttributedString alloc] initWithString:stringToDraw attributes:attribs];

    // Flip the context coordinates
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    // draw
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextSetTextPosition(ctx, CGRectGetMidX(self.bounds), 1);
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attributedStringToDraw);

    CGRect textBounds = CTLineGetImageBounds(line, ctx);
    CGContextFillRect(ctx, textBounds);
    CTLineDraw(line, ctx);

    // clean up
    CFRelease(line);
    CFRelease(font);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0, -self.bounds.size.height);

    // Draw bracket
    if (geom->bracket()) {
        CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);

        CGRect bounds = self.bounds;
        CGRect lineRect;

        lineRect.origin.x = 0;
        if (geom->placement() == mxml::dom::Placement::Above)
            lineRect.origin.y = CGRectGetMidY(bounds);
        else
            lineRect.origin.y = 0;
        lineRect.size.width = kLineWidth;
        lineRect.size.height = CGRectGetHeight(bounds)/2;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));

        lineRect.origin.x = CGRectGetMaxX(bounds) - kLineWidth;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));

        lineRect.origin.x = 0;
        lineRect.origin.y = CGRectGetMidY(bounds);
        lineRect.size.width = CGRectGetMinX(textBounds) - 4;
        lineRect.size.height = kLineWidth;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));

        lineRect.origin.x = CGRectGetMaxX(textBounds) + 4;
        lineRect.size.width = CGRectGetWidth(bounds) - lineRect.origin.x;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));
    }
}


@end
