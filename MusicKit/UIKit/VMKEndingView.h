// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementContainerView.h"
#import "VMKEndingLayer.h"


@interface VMKEndingView : VMKScoreElementContainerView

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeometry;

@property(nonatomic) const mxml::EndingGeometry* endingGeometry;
@property(nonatomic, readonly) VMKEndingLayer* endingLayer;

@end
