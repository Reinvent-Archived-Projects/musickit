//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/TieGeometry.h>


@interface VMKTieLayer : VMKScoreElementImageLayer

- (instancetype)initWithTieGeometry:(const mxml::TieGeometry*)tieGeometry;

@property(nonatomic) const mxml::TieGeometry* tieGeometry;

/**
 Draw bezier curve controls points, only for debugging.
 */
@property(nonatomic) BOOL drawControlPoints;

@end
