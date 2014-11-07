//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/PartGeometry.h>


@interface VMKBraceLayer : VMKScoreElementImageLayer

/**
 Get the image name for a brace of the given height.
 */
+ (NSString*)braceImageNameForHeight:(CGFloat)height;

- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)geom;

@property(nonatomic) const mxml::PartGeometry* partGeometry;

@end
