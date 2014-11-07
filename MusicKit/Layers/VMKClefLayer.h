//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/ClefGeometry.h>


@interface VMKClefLayer : VMKScoreElementImageLayer

/**
 Get the image name for a particular clef sign at a particular scale.
 */
+ (NSString*)imageNameForSign:(mxml::dom::Clef::Sign)sign;

- (instancetype)initWithClefGeometry:(const mxml::ClefGeometry*)clefGeom;

@property(nonatomic) const mxml::ClefGeometry* clefGeometry;

@end
