// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/RestGeometry.h>


@interface VMKRestLayer : VMKScoreElementImageLayer

+ (NSString*)headImageNameForType:(mxml::dom::Optional<mxml::dom::Note::Type>)type;

- (instancetype)initWithRestGeometry:(const mxml::RestGeometry*)restGeom;

@property(nonatomic) const mxml::RestGeometry*restGeometry;

@end
