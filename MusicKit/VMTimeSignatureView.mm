//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMTimeSignatureView.h"
#import "VMDrawing.h"
#import "VMImageStore.h"

using namespace mxml;

static const CGFloat kVerticalSpacing = 1;
static const CGFloat kHorizontalSpacing = 0;


@implementation VMTimeSignatureView

+ (UIImage*)imageForSymbol:(dom::Time::Symbol)symbol {
    if (symbol == dom::Time::SYMBOL_COMMON)
        return [[VMImageStore sharedInstance] imageNamed:@"common"];
    return nil;
}

+ (NSArray*)imagesForNumber:(int)number {
    NSMutableArray* array = [NSMutableArray array];
    
    // Special case when number is zero
    if (number == 0) {
        [array addObject:[self imageForDigit:number]];
        return array;
    }
    
    while (number > 0) {
        int digit = number % 10;
        [array insertObject:[self imageForDigit:digit] atIndex:0];
        number /= 10;
    }
    
    return array;
}

+ (UIImage*)imageForDigit:(int)digit {
    NSString* name = [NSString stringWithFormat:@"numeral-%d", digit];
    return [[VMImageStore sharedInstance] imageNamed:name];
}

+ (CGSize)sizeForImages:(NSArray*)images {
    CGSize size = CGSizeZero;
    for (UIImage* image in images) {
        size.width += image.size.width + kHorizontalSpacing;
        size.height = MAX(size.height, image.size.height);
    }
    if (size.width > kHorizontalSpacing)
        size.width -= kHorizontalSpacing;
    return size;
}

- (id)initWithTimeSignatureGeometry:(const TimeSignatureGeometry*)timeGeom {
    return [super initWithGeometry:timeGeom];
}

- (const TimeSignatureGeometry*)timeSignatureGeometry {
    return static_cast<const TimeSignatureGeometry*>(self.geometry);
}

- (void)setGeometry:(const Geometry*)geometry {
    BOOL changed = geometry != self.geometry;
    [super setGeometry:geometry];
    if (changed)
        [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.geometry)
        return;
    CGSize size = self.bounds.size;
    
    const dom::Time& time = self.timeSignatureGeometry->time();
    
    UIImage* image = [[self class] imageForSymbol:time.symbol()];
    if (image) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        return;
    }
    
    NSArray* topImages = [[self class] imagesForNumber:time.beats()];
    CGSize topSize = [[self class] sizeForImages:topImages];
    
    NSArray* bottomImages = [[self class] imagesForNumber:time.beatType()];
    CGSize bottomSize = [[self class] sizeForImages:bottomImages];
    
    CGRect imageRect;
    imageRect.origin.x = (size.width - topSize.width) / 2;
    imageRect.origin.y = 0;
    imageRect.size = CGSizeZero;
    
    for (UIImage* image in topImages) {
        imageRect.size.width = image.size.width;
        imageRect.size.height = image.size.height;
        [image drawInRect:VMRoundRect(imageRect)];
        
        imageRect.origin.x += image.size.width + kHorizontalSpacing;
    }
    
    imageRect.origin.x = (size.width - bottomSize.width) / 2;
    imageRect.origin.y = topSize.height + kVerticalSpacing;
    imageRect = VMRoundRect(imageRect);
    
    for (UIImage* image in bottomImages) {
        imageRect.size.width = image.size.width;
        imageRect.size.height = image.size.height;
        [image drawInRect:VMRoundRect(imageRect)];
        
        imageRect.origin.x += image.size.width + kHorizontalSpacing;
    }
}

@end
