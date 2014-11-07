//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/BeamGeometry.h>


/** A layer for a set of chords that share the same beams. */
@interface VMKBeamLayer : VMKScoreElementLayer

- (instancetype)initWithBeamGeometry:(const mxml::BeamGeometry*)beamGeometry;

@property(nonatomic) const mxml::BeamGeometry* beamGeometry;

@end
