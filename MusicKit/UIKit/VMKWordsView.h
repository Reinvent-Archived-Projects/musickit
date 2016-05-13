// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementContainerView.h"
#import "VMKWordsLayer.h"


@interface VMKWordsView : VMKScoreElementContainerView

- (instancetype)initWithWordsGeometry:(const mxml::WordsGeometry*)wordsGeom;

@property(nonatomic) const mxml::WordsGeometry* wordsGeometry;
@property(nonatomic, readonly) VMKWordsLayer* wordsLayer;

@end
