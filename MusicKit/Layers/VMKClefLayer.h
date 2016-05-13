// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/ClefGeometry.h>


@interface VMKClefLayer : VMKScoreElementImageLayer

/**
 Get the image name for a particular clef sign at a particular scale.
 */
+ (NSString*)imageNameForSign:(mxml::dom::Clef::Sign)sign;

- (instancetype)initWithClefGeometry:(const mxml::ClefGeometry*)clefGeom;

@property(nonatomic) const mxml::ClefGeometry* clefGeometry;

@end
