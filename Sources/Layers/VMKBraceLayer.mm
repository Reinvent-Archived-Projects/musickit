// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKBraceLayer.h"

#import "VMKGeometry.h"

#include <mxml/Metrics.h>

static const CGFloat kBraceWidth = 14.0;


@implementation VMKBraceLayer

+ (NSString*)braceImageNameForHeight:(CGFloat)height {
    NSString* imageName;
    if (height > 165)
        imageName = @"brace-185";
    else if (height > 145)
        imageName = @"brace-165";
    else if (height > 125)
        imageName = @"brace-145";
    else if (height > 105)
        imageName = @"brace-125";
    else
        imageName = @"brace-105";

    return imageName;
}

- (id)initWithPartGeometry:(const mxml::PartGeometry*)geom {
    return [super initWithGeometry:geom];
}

- (const mxml::PartGeometry*)partGeometry {
    return static_cast<const mxml::PartGeometry*>(self.geometry);
}

- (void)setPartGeometry:(const mxml::PartGeometry *)partGeometry {
    self.geometry = partGeometry;
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];

    if (!geometry) {
        self.imageName = nil;
        return;
    }

    CGFloat stavesHeight = (CGFloat)self.partGeometry->stavesHeight();
    self.imageName = [[self class] braceImageNameForHeight:stavesHeight];
    self.anchorPoint = CGPointMake(0, 0.5);
    self.bounds = {CGPointZero, self.preferredFrameSize};
}

- (CGSize)preferredFrameSize {
    if (self.geometry == 0)
        return CGSizeZero;

    CGSize baseSize = self.image.size;
    if (baseSize.height == 0)
        return CGSizeZero;

    CGFloat scale = self.partGeometry->stavesHeight() / baseSize.height;
    return CGSizeMake(kBraceWidth, baseSize.height * scale);
}

@end
