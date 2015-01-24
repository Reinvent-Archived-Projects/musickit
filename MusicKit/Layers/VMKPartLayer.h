//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/PartGeometry.h>


@interface VMKPartLayer : VMKScoreElementLayer

- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)partGeometry;

@property(nonatomic) const mxml::PartGeometry* partGeometry;

@end
