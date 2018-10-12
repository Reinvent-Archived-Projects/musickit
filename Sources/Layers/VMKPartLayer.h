// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/PartGeometry.h>


@interface VMKPartLayer : VMKScoreElementLayer

- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)partGeometry;
- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)partGeometry noteColors:(NSArray *)noteColors;

@property(nonatomic) const mxml::PartGeometry* partGeometry;

@end
