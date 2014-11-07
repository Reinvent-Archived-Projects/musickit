//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKTieLayer.h"


@interface VMKTieView : VMKScoreElementContainerView

- (instancetype)initWithTieGeometry:(const mxml::TieGeometry*)tieGeometry;

@property(nonatomic) const mxml::TieGeometry* tieGeometry;
@property(nonatomic, readonly) VMKTieLayer* tieLayer;

@end
