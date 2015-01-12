//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/KeyGeometry.h>
#include <mxml/dom/Clef.h>


@interface VMKKeyLayer : VMKScoreElementLayer

- (instancetype)initWithKeyGeometry:(const mxml::KeyGeometry*)keyGeom;

@property(nonatomic) const mxml::KeyGeometry* keyGeometry;
@property(nonatomic) const mxml::dom::Clef* clef;
@property(nonatomic) BOOL hideNaturals;

@end
