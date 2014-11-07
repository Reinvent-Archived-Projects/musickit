//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKCursorView.h"

const CGFloat VMCursorAlpha = 0.25;
const CGFloat VMCursorFadeOutLength = 40;


@implementation VMKCursorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.color = [UIColor colorWithRed:1 green:94/255.f blue:57/255.f alpha:1];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    self.color = [UIColor colorWithRed:1 green:94/255.f blue:57/255.f alpha:1];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[self.color colorWithAlphaComponent:VMCursorAlpha] setFill];
    CGContextFillRect(ctx, CGRectMake(0, VMCursorFadeOutLength, size.width, size.height - 2*VMCursorFadeOutLength));

    CGGradientRef gradient = [self createGradient];
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(size.width/2, VMCursorFadeOutLength), CGPointMake(size.width/2, 0), 0);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(size.width/2, size.height - VMCursorFadeOutLength), CGPointMake(size.width/2, size.height), 0);
    CGGradientRelease(gradient);
}

- (CGGradientRef)createGradient {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat components[8] = {0};
    [self.color getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
    components[3] = VMCursorAlpha;
    components[4] = components[0];
    components[5] = components[1];
    components[6] = components[2];
    components[7] = 0;

    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
    CGColorSpaceRelease(colorSpace);

    return gradient;
}

@end
