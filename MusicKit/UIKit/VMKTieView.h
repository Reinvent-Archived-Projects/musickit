// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementContainerView.h"
#import "VMKTieLayer.h"


@interface VMKTieView : VMKScoreElementContainerView

- (instancetype)initWithTieGeometry:(const mxml::TieGeometry*)tieGeometry;

@property(nonatomic) const mxml::TieGeometry* tieGeometry;
@property(nonatomic, readonly) VMKTieLayer* tieLayer;

@end
