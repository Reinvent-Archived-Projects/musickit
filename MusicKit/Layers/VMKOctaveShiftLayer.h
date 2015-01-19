//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/SpanDirectionGeometry.h>


@interface VMKOctaveShiftLayer : VMKScoreElementLayer

- (instancetype)initWithSpanDirectionGeometry:(const mxml::SpanDirectionGeometry*)geom;

@property(nonatomic) const mxml::SpanDirectionGeometry* spanDirectionGeometry;

@end
