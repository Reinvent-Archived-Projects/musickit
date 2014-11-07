//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/BarlineGeometry.h>


@interface VMKBarlineLayer : VMKScoreElementLayer

- (instancetype)initWithBarlineGeometry:(const mxml::BarlineGeometry*)barlineGeom;

@property(nonatomic) const mxml::BarlineGeometry* barlineGeometry;

@end
