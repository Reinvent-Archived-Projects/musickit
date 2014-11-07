//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKPedalLayer.h"


@interface VMKPedalView : VMKScoreElementContainerView

- (instancetype)initWithPedalGeometry:(const mxml::SpanDirectionGeometry*)pedalGeomerty;

@property(nonatomic) const mxml::SpanDirectionGeometry* pedalGeometry;
@property(nonatomic, readonly) VMKPedalLayer* pedalLayer;

@end
