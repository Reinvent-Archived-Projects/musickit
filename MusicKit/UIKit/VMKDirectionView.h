//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKDirectionLayer.h"


@interface VMKDirectionView : VMKScoreElementContainerView

- (instancetype)initWithDirectionGeometry:(const mxml::DirectionGeometry*)directionGeom;

@property(nonatomic) const mxml::DirectionGeometry* directionGeometry;
@property(nonatomic, readonly) VMKDirectionLayer* directionLayer;

@end
