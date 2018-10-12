// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/MeasureGeometry.h>

extern const CGFloat VMKStaffLineWidth;
extern const CGFloat VMKBarLineWidth;


@interface VMKMeasureLayer : VMKScoreElementLayer

- (instancetype)initWithMeasure:(const mxml::MeasureGeometry*)measureGeom;

@property(nonatomic) const mxml::MeasureGeometry* measureGeometry;
@property(nonatomic, strong) NSArray<VMKColor *>* noteColors;

@end
