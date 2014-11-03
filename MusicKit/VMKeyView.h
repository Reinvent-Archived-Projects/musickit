//  Created by Alejandro Isaza on 2014-05-13.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "KeyGeometry.h"
#include "Clef.h"

@interface VMKeyView : VMScoreElementView

- (id)initWithKeyGeometry:(const mxml::KeyGeometry*)keyGeom;

@property(nonatomic) const mxml::KeyGeometry* keyGeometry;
@property(nonatomic) const mxml::dom::Clef* clef;

@end
