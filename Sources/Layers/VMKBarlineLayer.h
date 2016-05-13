// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/BarlineGeometry.h>


@interface VMKBarlineLayer : VMKScoreElementLayer

- (instancetype)initWithBarlineGeometry:(const mxml::BarlineGeometry*)barlineGeom;

@property(nonatomic) const mxml::BarlineGeometry* barlineGeometry;

@end
