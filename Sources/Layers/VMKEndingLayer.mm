// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKEndingLayer.h"
#import "VMKGeometry.h"

#import <CoreText/CoreText.h>


@implementation VMKEndingLayer

static const CGFloat kLineWidth = 1;

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeom {
    return [super initWithGeometry:endingGeom];
}

- (const mxml::EndingGeometry*)endingGeometry {
    return static_cast<const mxml::EndingGeometry*>(self.geometry);
}

- (void)setEndingGeometry:(const mxml::EndingGeometry *)endingGeometry {
    [self setGeometry:endingGeometry];
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    const mxml::EndingGeometry* geom = self.endingGeometry;

    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.foregroundColor.CGColor);
    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);


    CGSize size = self.bounds.size;
    CGRect fillRect;
    fillRect.origin = CGPointZero;
    fillRect.size.width = kLineWidth;
    fillRect.size.height = size.height;
    CGContextFillRect(ctx, VMKRoundRect(fillRect));

    fillRect.size.width = geom->size().width;
    fillRect.size.height = kLineWidth;
    CGContextFillRect(ctx, VMKRoundRect(fillRect));

    if (geom->stopEnding().type() == mxml::dom::Ending::Type::Stop) {
        fillRect.origin.x = size.width - kLineWidth;
        fillRect.size.width = kLineWidth;
        fillRect.size.height = size.height;
        CGContextFillRect(ctx, VMKRoundRect(fillRect));
    }

    NSMutableString* string = [NSMutableString string];
    for (auto& number : geom->stopEnding().numbers()) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendFormat:@"%d.", number];
    }

    CTFontRef font = CTFontCreateWithName(CFSTR("Baskerville"), 13.0, NULL);
    NSDictionary* attribs = @{ (id)kCTFontAttributeName: (__bridge id)font };
    NSAttributedString* stringToDraw = [[NSAttributedString alloc] initWithString:string attributes:attribs];

    // Flip the context coordinates, in iOS only.
#if TARGET_OS_IPHONE
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
#endif

    // draw
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextSetTextPosition(ctx, 2*kLineWidth, kLineWidth);
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
    CTLineDraw(line, ctx);

    // clean up
    CFRelease(line);
    CFRelease(font);
}

@end
