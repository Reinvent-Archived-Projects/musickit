//  Created by Alejandro Isaza on 2014-04-21.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "TieGeometry.h"

@interface VMTieView : VMScoreElementView

- (id)initWithTieGeometry:(const mxml::TieGeometry*)tieGeom;

/**
 Draw bezier curve controls points, only for debugging.
 */
@property(nonatomic) BOOL drawControlPoints;

@end
