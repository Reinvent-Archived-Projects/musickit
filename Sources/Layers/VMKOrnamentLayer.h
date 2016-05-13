// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/OrnamentsGeometry.h>


@interface VMKOrnamentLayer : VMKScoreElementImageLayer

+ (NSString*)imageNameForOrnaments:(const mxml::dom::Ornaments&)ornaments;

- (instancetype)initWithOrnamentsGeometry:(const mxml::OrnamentsGeometry*)ornamentsGeometry;

@property(nonatomic) const mxml::OrnamentsGeometry* ornamentsGeometry;

@end
