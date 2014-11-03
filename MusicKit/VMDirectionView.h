//  Created by Alejandro Isaza on 2014-04-17.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "DirectionGeometry.h"

@interface VMDirectionView : VMScoreElementView

- (id)initWithDirectionGeometry:(const mxml::DirectionGeometry*)directionGeom;

- (const mxml::DirectionGeometry*)directionGeometry;

@property(nonatomic, strong) UILabel* label;

@end
