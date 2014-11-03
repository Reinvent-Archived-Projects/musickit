//  Created by Alejandro Isaza on 2014-06-16.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "SpanDirectionGeometry.h"

@interface VMPedalView : VMScoreElementView

- (id)initWithSpanDirectionGeometry:(const mxml::SpanDirectionGeometry*)geom;

@property(nonatomic) const mxml::SpanDirectionGeometry* spanDirectionGeometry;

@end
