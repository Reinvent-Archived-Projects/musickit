// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/SystemGeometry.h>


@interface VMKSystemLayer : VMKScoreElementLayer

- (instancetype)initWithSystemGeometry:(const mxml::SystemGeometry*)systemGeometry;

@property(nonatomic) const mxml::SystemGeometry* systemGeometry;
@property(nonatomic, strong) NSArray* noteColors;

@end
