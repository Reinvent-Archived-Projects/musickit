//  Created by Alejandro Isaza on 2014-05-13.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKeyView.h"
#import "VMImageStore.h"

#include "MeasureGeometry.h"
#include "PartGeometry.h"
#include <cstdlib>

using namespace mxml;


@implementation VMKeyView

- (id)initWithKeyGeometry:(const mxml::KeyGeometry*)keyGeom {
    return [super initWithGeometry:keyGeom];
}

- (const KeyGeometry*)keyGeometry {
    return static_cast<const KeyGeometry*>(self.geometry);
}

- (void)setKeyGeometry:(const mxml::KeyGeometry*)keyGeometry {
    self.geometry = keyGeometry;
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    BOOL changed = geometry != self.geometry;
    [super setGeometry:geometry];

    if (geometry)
        _clef = &self.keyGeometry->clef();

    if (changed)
        [self setNeedsDisplay];
}

- (void)setClef:(const mxml::dom::Clef *)clef {
    _clef = clef;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.geometry)
        return;

    const KeyGeometry& keyGeom = *self.keyGeometry;
    const dom::Key& key = keyGeom.key();

    NSString* imageName;
    if (key.fifths() < 0)
        imageName = @"flat";
    else
        imageName = @"sharp";
    UIImage* image = [[VMImageStore sharedInstance] imageNamed:imageName];

    CGFloat originY = self.bounds.size.height/2 - PartGeometry::staffHeight()/2;
    CGRect imageRect;
    imageRect.origin.x = 0;
    imageRect.size = image.size;
    for (int fifth = 1; fifth <= std::abs(key.fifths()); fifth += 1) {
        imageRect.origin.y = originY + self.keyGeometry->keyStaffY(key.fifths() > 0 ? fifth : -fifth, *_clef) - imageRect.size.height/2;
        [image drawInRect:imageRect];
        imageRect.origin.x += imageRect.size.width + KeyGeometry::kSpacing;
    }
}

@end
