// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/EndingGeometry.h>


@interface VMKEndingLayer : VMKScoreElementLayer

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeom;

@property(nonatomic) const mxml::EndingGeometry* endingGeometry;

@end
