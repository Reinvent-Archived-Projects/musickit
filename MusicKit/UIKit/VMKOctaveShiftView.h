// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementContainerView.h"
#import "VMKOctaveShiftLayer.h"


@interface VMKOctaveShiftView : VMKScoreElementContainerView

- (instancetype)initWithOctaveShiftGeometry:(const mxml::SpanDirectionGeometry*)pedalGeomerty;

@property(nonatomic) const mxml::SpanDirectionGeometry* octaveShiftGeometry;
@property(nonatomic, readonly) VMKOctaveShiftLayer* octaveShiftLayer;

@end
