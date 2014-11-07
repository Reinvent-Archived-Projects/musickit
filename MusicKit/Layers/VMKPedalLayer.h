//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/SpanDirectionGeometry.h>


@interface VMKPedalLayer : VMKScoreElementLayer

- (instancetype)initWithSpanDirectionGeometry:(const mxml::SpanDirectionGeometry*)geom;

@property(nonatomic) const mxml::SpanDirectionGeometry* spanDirectionGeometry;

@end
