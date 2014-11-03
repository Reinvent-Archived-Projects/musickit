//  Created by Alejandro Isaza on 2014-04-01.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementImageView.h"
#include "ClefGeometry.h"

@interface VMClefView : VMScoreElementImageView

/**
 Get the image name for a particular clef sign at a particular scale.
 */
+ (NSString*)imageNameForSign:(mxml::dom::Clef::Sign)sign;

- (id)initWithClefGeometry:(const mxml::ClefGeometry*)clefGeom;

- (const mxml::ClefGeometry*)clefGeometry;

@end
