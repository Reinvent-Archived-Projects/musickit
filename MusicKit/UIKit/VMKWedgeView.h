//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKWedgeLayer.h"


@interface VMKWedgeView : VMKScoreElementContainerView

- (instancetype)initWithWedgeGeometry:(const mxml::SpanDirectionGeometry*)geometry;

@property(nonatomic) const mxml::SpanDirectionGeometry* wedgeGeometry;
@property(nonatomic, readonly) VMKWedgeLayer* wedgeLayer;

@end
