//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/AccidentalGeometry.h>


@interface VMKAccidentalLayer : VMKScoreElementLayer

- (instancetype)initWithAccidentalGeometry:(const mxml::AccidentalGeometry*)accidentalGeometry;

@property(nonatomic) const mxml::AccidentalGeometry* accidentalGeometry;

@end
