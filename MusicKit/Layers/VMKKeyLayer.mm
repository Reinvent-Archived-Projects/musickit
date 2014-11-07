//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKKeyLayer.h"
#import "VMKImageStore.h"

#include <mxml/geometry/MeasureGeometry.h>
#include <mxml/geometry/PartGeometry.h>
#include <cstdlib>


@implementation VMKKeyLayer

- (instancetype)initWithKeyGeometry:(const mxml::KeyGeometry*)keyGeom {
    return [super initWithGeometry:keyGeom];
}

- (const mxml::KeyGeometry*)keyGeometry {
    return static_cast<const mxml::KeyGeometry*>(self.geometry);
}

- (void)setKeyGeometry:(const mxml::KeyGeometry*)keyGeometry {
    self.geometry = keyGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    BOOL changed = geometry != self.geometry;
    [super setGeometry:geometry];

    if (geometry)
        _clef = &self.keyGeometry->clef();

    if (changed)
        [self setNeedsDisplay];
}

- (void)setClef:(const mxml::dom::Clef*)clef {
    _clef = clef;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    if (!self.geometry)
        return;

    const mxml::KeyGeometry& keyGeom = *self.keyGeometry;
    const mxml::dom::Key& key = keyGeom.key();

    NSString* imageName;
    if (key.fifths() < 0)
        imageName = @"flat";
    else
        imageName = @"sharp";
    VMKImage* image = [[VMKImageStore sharedInstance] imageNamed:imageName];

    CGFloat originY = self.bounds.size.height/2 - mxml::PartGeometry::staffHeight()/2;
    CGRect imageRect;
    imageRect.origin.x = 0;
    imageRect.size = image.size;
    for (int fifth = 1; fifth <= std::abs(key.fifths()); fifth += 1) {
        imageRect.origin.y = originY + self.keyGeometry->keyStaffY(key.fifths() > 0 ? fifth : -fifth, *_clef) - imageRect.size.height/2;
        [image drawInRect:imageRect];
        imageRect.origin.x += imageRect.size.width + mxml::KeyGeometry::kSpacing;
    }
}

@end
