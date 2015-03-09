//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/TupletGeometry.h>


@interface VMKTupletLayer : VMKScoreElementLayer

- (instancetype)initWithTupletGeometry:(const mxml::TupletGeometry*)geom;

@property(nonatomic) const mxml::TupletGeometry* tupletGeometry;

@end
