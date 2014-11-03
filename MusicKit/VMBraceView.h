//  Created by Alejandro Isaza on 2014-04-16.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementImageView.h"
#include "PartGeometry.h"

extern const CGFloat kBraceWidth;

@interface VMBraceView : VMScoreElementImageView

/**
 Get the image name for a brace of the given height.
 */
+ (NSString*)braceImageNameForHeight:(CGFloat)height;

- (id)initWithPartGeometry:(const mxml::PartGeometry*)geom;

@property(nonatomic) const mxml::PartGeometry* partGeometry;

@end
