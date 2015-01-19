//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKOctaveShiftLayer.h"


@interface VMKOctaveShiftView : VMKScoreElementContainerView

- (instancetype)initWithOctaveShiftGeometry:(const mxml::SpanDirectionGeometry*)pedalGeomerty;

@property(nonatomic) const mxml::SpanDirectionGeometry* octaveShiftGeometry;
@property(nonatomic, readonly) VMKOctaveShiftLayer* octaveShiftLayer;

@end
