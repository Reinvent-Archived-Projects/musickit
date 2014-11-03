//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "geometry/MeasureGeometry.h"

@interface VMMeasureView : VMScoreElementView

- (id)initWithMeasure:(const mxml::MeasureGeometry*)measureGeom;

@property(nonatomic) const mxml::MeasureGeometry* measureGeometry;
@property(nonatomic, strong) UIColor* bookmarkedColor;
@property(nonatomic, getter = isBookmarked) BOOL bookmarked;

- (void)setBookmarked:(BOOL)bookmarked animated:(BOOL)animated;

@end
