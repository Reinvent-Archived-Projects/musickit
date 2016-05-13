// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKKeyLayer.h"
#import "VMKImageStore.h"
#import "VMKGeometry.h"

#include <mxml/geometry/MeasureGeometry.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/Metrics.h>

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

    if (geometry) {
        _clef = &self.keyGeometry->clef();
        assert(_clef);
    }

    if (changed)
        [self setNeedsDisplay];
}

- (void)setClef:(const mxml::dom::Clef*)clef {
    assert(clef);
    _clef = clef;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    if (!self.geometry)
        return;

    const mxml::KeyGeometry& keyGeom = *self.keyGeometry;
    const mxml::dom::Key& key = keyGeom.key();

    if (keyGeom.natural() && _hideNaturals)
        return;
    
    NSString* imageName;
    if (keyGeom.natural())
        imageName = @"natural";
    else if (key.fifths() < 0)
        imageName = @"flat";
    else
        imageName = @"sharp";
    
    VMKImage* image = [[VMKImageStore sharedInstance] imageNamed:imageName withColor:self.foregroundColor];

    CGFloat originY = self.bounds.size.height/2 - mxml::Metrics::staffHeight()/2;
    CGRect imageRect;
    imageRect.origin.x = 0;
    imageRect.size = image.size;
    for (int fifth = 1; fifth <= std::abs(key.fifths()); fifth += 1) {
        imageRect.origin.y = originY + self.keyGeometry->keyStaffY(key.fifths() > 0 ? fifth : -fifth, *_clef) - imageRect.size.height/2;
        [image drawInRect:VMKRoundRect(imageRect)];
        imageRect.origin.x += imageRect.size.width + mxml::KeyGeometry::kSpacing;
    }
}

@end
