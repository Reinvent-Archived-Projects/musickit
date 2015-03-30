//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAccidentalLayer.h"
#import "VMKColor.h"
#import "VMKGeometry.h"
#import "VMKImageStore.h"


@implementation VMKAccidentalLayer

+ (NSArray*)imagesForAccidental:(int)alter withColor:(VMKColor*)color {
    VMKImageStore* imageStore = [VMKImageStore sharedInstance];
    if (alter == -2) {
        VMKImage* image = [imageStore imageNamed:@"flat" withColor:color];
        return @[ image, image ];
    }

    auto type = mxml::dom::Accidental::Type::byAlter(alter);
    if (!type)
        return nil;

    NSString* imageName = [NSString stringWithUTF8String:type->name];
    return @[ [imageStore imageNamed:imageName withColor:color] ];
}

+ (CGSize)sizeForImages:(NSArray*)images {
    CGSize size = CGSizeZero;
    for (VMKImage* image in images) {
        size.width += image.size.width;
        size.height = MAX(size.height, image.size.height);
    }
    return size;
}

- (instancetype)initWithAccidentalGeometry:(const mxml::AccidentalGeometry*)accidentalGeom {
    return [super initWithGeometry:accidentalGeom];
}

- (const mxml::AccidentalGeometry*)accidentalGeometry {
    return static_cast<const mxml::AccidentalGeometry*>(self.geometry);
}

- (void)setAccidentalGeometry:(const mxml::AccidentalGeometry *)accidentalGeometry {
    [super setGeometry:accidentalGeometry];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    CGSize size = self.bounds.size;

    NSArray* images = [[self class] imagesForAccidental:self.accidentalGeometry->alter() withColor:self.foregroundColor];
    CGSize imagesSize = [[self class] sizeForImages:images];

    CGFloat scale = size.width / imagesSize.width;

    CGRect imageRect;
    imageRect.origin.x = (size.width - imagesSize.width) / 2;
    imageRect.origin.y = (size.height - imagesSize.height) / 2;

    for (VMKImage* image in images) {
        imageRect.size.width = image.size.width*scale;
        imageRect.size.height = image.size.height*scale;
        [image drawInRect:VMKRoundRect(imageRect)];

        imageRect.origin.x += image.size.width;
    }
}

@end
