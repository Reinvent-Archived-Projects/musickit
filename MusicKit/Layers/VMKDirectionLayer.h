//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/DirectionGeometry.h>


@interface VMKDirectionLayer : VMKScoreElementLayer

- (instancetype)initWithDirectionGeometry:(const mxml::DirectionGeometry*)directionGeom;

@property(nonatomic) const mxml::DirectionGeometry* directionGeometry;
@property(nonatomic, strong) CATextLayer* textLayer;

@end
