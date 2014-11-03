//  Created by Alejandro Isaza on 2014-06-24.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "EndingGeometry.h"

@interface VMEndingView : VMScoreElementView

- (id)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeom;

@property(nonatomic) const mxml::EndingGeometry* endingGeometry;

@end
