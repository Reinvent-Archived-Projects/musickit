//  Created by Alejandro Isaza on 2014-04-10.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "BeamGeometry.h"

/** A view for a set of chords that share the same beams. */
@interface VMBeamView : VMScoreElementView

- (id)initWithBeamGeometry:(const mxml::BeamGeometry*)beamGeometry;

- (const mxml::BeamGeometry*)beamGeometry;

@end
