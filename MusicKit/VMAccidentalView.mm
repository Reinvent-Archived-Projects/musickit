//  Created by Alejandro Isaza on 2014-04-17.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMAccidentalView.h"
#import "VMImageStore.h"
#import "VMDrawing.h"

using namespace mxml;


@implementation VMAccidentalView

+ (NSArray*)imagesForAccidental:(const dom::Accidental&)accidental {
    VMImageStore* imageStore = [VMImageStore sharedInstance];

    switch (accidental.type()) {
        case dom::Accidental::TYPE_SHARP:
            return @[ [imageStore imageNamed:@"sharp"] ];
            
        case dom::Accidental::TYPE_FLAT:
            return @[ [imageStore imageNamed:@"flat"] ];
            
        case dom::Accidental::TYPE_NATURAL:
            return @[ [imageStore imageNamed:@"natural"] ];
            
        case dom::Accidental::TYPE_DOUBLE_SHARP:
            return @[ [imageStore imageNamed:@"double-sharp"] ];
            
        case dom::Accidental::TYPE_DOUBLE_FLAT: {
            UIImage* image = [imageStore imageNamed:@"flat"];
            return @[ image, image ];
        }
            
        default:
            return nil;
    }
}

+ (CGSize)sizeForImages:(NSArray*)images {
    CGSize size = CGSizeZero;
    for (UIImage* image in images) {
        size.width += image.size.width;
        size.height = MAX(size.height, image.size.height);
    }
    return size;
}

- (id)initWithAccidentalGeometry:(const AccidentalGeometry*)accidentalGeom {
    return [super initWithGeometry:accidentalGeom];
}

- (const AccidentalGeometry*)accidentalGeometry {
    return static_cast<const AccidentalGeometry*>(self.geometry);
}

- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    
    const dom::Accidental& accidental = self.accidentalGeometry->accidentail();
    NSArray* images = [[self class] imagesForAccidental:accidental];
    CGSize imagesSize = [[self class] sizeForImages:images];
    
    CGFloat scale = size.width / imagesSize.width;
    
    CGRect imageRect;
    imageRect.origin.x = (size.width - imagesSize.width) / 2;
    imageRect.origin.y = (size.height - imagesSize.height) / 2;
    
    for (UIImage* image in images) {
        imageRect.size.width = image.size.width*scale;
        imageRect.size.height = image.size.height*scale;
        [image drawInRect:VMRoundRect(imageRect)];
        
        imageRect.origin.x += image.size.width;
    }
}

@end
