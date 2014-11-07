//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#include <mxml/geometry/MeasureGeometry.h>


@interface VMKMeasureView : VMKScoreElementContainerView

- (instancetype)initWithMeasure:(const mxml::MeasureGeometry*)measureGeom;

@property(nonatomic) const mxml::MeasureGeometry* measureGeometry;
@property(nonatomic, strong) UIColor* bookmarkedColor;
@property(nonatomic, getter = isBookmarked) BOOL bookmarked;

- (void)setBookmarked:(BOOL)bookmarked animated:(BOOL)animated;

@end
