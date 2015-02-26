//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/StemGeometry.h>


@interface VMKNoteStemLayer : VMKScoreElementImageLayer

/**
 Get the image name for the note's stem.
 */
+ (NSString*)stemImageNameForNote:(const mxml::dom::Note&)note direction:(mxml::dom::Stem)stemDirection;

- (instancetype)initWithStemGeometry:(const mxml::StemGeometry*)stemGeom;

@property(nonatomic) const mxml::StemGeometry* stemGeometry;

@end
