//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/EndingGeometry.h>


@interface VMKEndingLayer : VMKScoreElementLayer

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeom;

@property(nonatomic) const mxml::EndingGeometry* endingGeometry;

@end
