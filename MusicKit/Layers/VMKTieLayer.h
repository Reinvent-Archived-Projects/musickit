// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/TieGeometry.h>


@interface VMKTieLayer : VMKScoreElementLayer

- (instancetype)initWithTieGeometry:(const mxml::TieGeometry*)tieGeometry;

@property(nonatomic) const mxml::TieGeometry* tieGeometry;

/**
 Draw bezier curve controls points, only for debugging.
 */
@property(nonatomic) BOOL drawControlPoints;

@end
