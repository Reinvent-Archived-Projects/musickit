// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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
