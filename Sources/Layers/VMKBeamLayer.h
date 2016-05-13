// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/BeamGeometry.h>


/** A layer for a set of chords that share the same beams. */
@interface VMKBeamLayer : VMKScoreElementLayer

- (instancetype)initWithBeamGeometry:(const mxml::BeamGeometry*)beamGeometry;

@property(nonatomic) const mxml::BeamGeometry* beamGeometry;

@end
