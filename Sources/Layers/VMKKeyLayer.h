// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/KeyGeometry.h>
#include <mxml/dom/Clef.h>


@interface VMKKeyLayer : VMKScoreElementLayer

- (instancetype)initWithKeyGeometry:(const mxml::KeyGeometry*)keyGeom;

@property(nonatomic) const mxml::KeyGeometry* keyGeometry;
@property(nonatomic) const mxml::dom::Clef* clef;
@property(nonatomic) BOOL hideNaturals;

@end
