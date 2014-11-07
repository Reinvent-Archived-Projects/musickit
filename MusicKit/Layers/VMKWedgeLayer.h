//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/SpanDirectionGeometry.h>


@interface VMKWedgeLayer : VMKScoreElementLayer

- (instancetype)initWithSpanDirectionGeometry:(const mxml::SpanDirectionGeometry*)geometry;

@property(nonatomic) const mxml::SpanDirectionGeometry* spanDirectionGeometry;

@end
