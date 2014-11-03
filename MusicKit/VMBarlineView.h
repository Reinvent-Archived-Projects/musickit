//  Created by Alejandro Isaza on 2014-05-01.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "BarlineGeometry.h"

@interface VMBarlineView : VMScoreElementView

- (id)initWithBarlineGeometry:(const mxml::BarlineGeometry*)barlineGeom;

@property(nonatomic) const mxml::BarlineGeometry* barlineGeometry;

@end
