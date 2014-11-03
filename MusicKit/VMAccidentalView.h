//  Created by Alejandro Isaza on 2014-04-17.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "AccidentalGeometry.h"


@interface VMAccidentalView : VMScoreElementView

- (id)initWithAccidentalGeometry:(const mxml::AccidentalGeometry*)accidentalGeom;

- (const mxml::AccidentalGeometry*)accidentalGeometry;

@end
