// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKCursorView.h"

const CGFloat VMCursorFadeOutLength = 40;


@implementation VMKCursorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.color = [UIColor colorWithRed:1 green:94/255.f blue:57/255.f alpha:1];
    self.opacity = 0.25;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    self.color = [UIColor colorWithRed:1 green:94/255.f blue:57/255.f alpha:1];
    self.opacity = 0.25;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setOpacity:(CGFloat)opacity {
    _opacity = opacity;
    [self setNeedsDisplay];
}

- (void)setCursorStyle:(VMKCursorStyle)cursorStyle {
    _cursorStyle = cursorStyle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[self.color colorWithAlphaComponent:self.opacity] setFill];
    if (self.cursorStyle == VMKCursorStyleNote) {
        CGContextFillRect(ctx, CGRectMake(0, VMCursorFadeOutLength, size.width, size.height - 2*VMCursorFadeOutLength));

        CGGradientRef gradient = [self newGradient];
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(size.width/2, VMCursorFadeOutLength), CGPointMake(size.width/2, 0), 0);
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(size.width/2, size.height - VMCursorFadeOutLength), CGPointMake(size.width/2, size.height), 0);
        CGGradientRelease(gradient);

    } else if (self.cursorStyle == VMKCursorStyleMeasure)  {
        CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    }
}

- (CGGradientRef)newGradient {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat components[8] = {0};
    [self.color getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
    components[3] = self.opacity;
    components[4] = components[0];
    components[5] = components[1];
    components[6] = components[2];
    components[7] = 0;

    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
    CGColorSpaceRelease(colorSpace);

    return gradient;
}

@end
