// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKGeometry.h"
#import "VMKImageStore.h"
#import "VMKTimeSignatureLayer.h"

using namespace mxml;

static const CGFloat kVerticalSpacing = 1;
static const CGFloat kHorizontalSpacing = 0;

@implementation VMKTimeSignatureLayer

+ (VMKImage*)imageForSymbol:(dom::Time::Symbol)symbol withColor:(VMKColor*)color {
    if (symbol == dom::Time::Symbol::Common)
        return [[VMKImageStore sharedInstance] imageNamed:@"common" withColor:color];
    return nil;
}

+ (NSArray*)imagesForNumber:(int)number withColor:(VMKColor*)color {
    NSMutableArray* array = [NSMutableArray array];

    // Special case when number is zero
    if (number == 0) {
        [array addObject:[self imageForDigit:number withColor:color]];
        return array;
    }

    while (number > 0) {
        int digit = number % 10;
        [array insertObject:[self imageForDigit:digit withColor:color] atIndex:0];
        number /= 10;
    }

    return array;
}

+ (VMKImage*)imageForDigit:(int)digit withColor:(VMKColor*)color {
    NSString* name = [NSString stringWithFormat:@"numeral-%d", digit];
    return [[VMKImageStore sharedInstance] imageNamed:name withColor:color];
}

+ (CGSize)sizeForImages:(NSArray*)images {
    CGSize size = CGSizeZero;
    for (VMKImage* image in images) {
        size.width += image.size.width + kHorizontalSpacing;
        size.height = MAX(size.height, image.size.height);
    }
    if (size.width > kHorizontalSpacing)
        size.width -= kHorizontalSpacing;
    return size;
}

- (instancetype)initWithTimeSignatureGeometry:(const TimeSignatureGeometry*)timeGeom {
    return [super initWithGeometry:timeGeom];
}

- (const TimeSignatureGeometry*)timeSignatureGeometry {
    return static_cast<const TimeSignatureGeometry*>(self.geometry);
}

- (void)setTimeSignatureGeometry:(const mxml::TimeSignatureGeometry*)timeSignatureGeometry {
    [self setGeometry:timeSignatureGeometry];
}

- (void)setGeometry:(const Geometry*)geometry {
    BOOL changed = geometry != self.geometry;
    [super setGeometry:geometry];
    if (changed)
        [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    if (!self.geometry)
        return;
    CGSize size = self.bounds.size;

    const dom::Time& time = self.timeSignatureGeometry->time();

    VMKImage* image = [[self class] imageForSymbol:time.symbol() withColor:self.foregroundColor];
    if (image) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        return;
    }

    NSArray* topImages = [[self class] imagesForNumber:time.beats() withColor:self.foregroundColor];
    CGSize topSize = [[self class] sizeForImages:topImages];

    NSArray* bottomImages = [[self class] imagesForNumber:time.beatType() withColor:self.foregroundColor];
    CGSize bottomSize = [[self class] sizeForImages:bottomImages];

    CGRect imageRect;
    imageRect.origin.x = (size.width - topSize.width) / 2;
    imageRect.origin.y = 0;
    imageRect.size = CGSizeZero;

    for (VMKImage* image in topImages) {
        imageRect.size.width = image.size.width;
        imageRect.size.height = image.size.height;
        [image drawInRect:VMKRoundRect(imageRect)];

        imageRect.origin.x += image.size.width + kHorizontalSpacing;
    }

    imageRect.origin.x = (size.width - bottomSize.width) / 2;
    imageRect.origin.y = topSize.height + kVerticalSpacing;
    imageRect = VMKRoundRect(imageRect);

    for (VMKImage* image in bottomImages) {
        imageRect.size.width = image.size.width;
        imageRect.size.height = image.size.height;
        [image drawInRect:VMKRoundRect(imageRect)];

        imageRect.origin.x += image.size.width + kHorizontalSpacing;
    }
}

@end
