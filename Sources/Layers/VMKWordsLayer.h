// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/WordsGeometry.h>


@interface VMKWordsLayer : VMKScoreElementLayer

- (instancetype)initWithWordsGeometry:(const mxml::WordsGeometry*)wordsGeom;

@property(nonatomic) const mxml::WordsGeometry* wordsGeometry;
@property(nonatomic, strong) CATextLayer* textLayer;

@end
