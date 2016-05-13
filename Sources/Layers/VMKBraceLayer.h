// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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
