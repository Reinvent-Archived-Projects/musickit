//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKEndingLayer.h"


@interface VMKEndingView : VMKScoreElementContainerView

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeometry;

@property(nonatomic) const mxml::EndingGeometry* endingGeometry;
@property(nonatomic, readonly) VMKEndingLayer* endingLayer;

@end
