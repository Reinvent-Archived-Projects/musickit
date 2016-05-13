// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKWordsView.h"


@implementation VMKWordsView

+ (Class)layerClass {
    return[VMKWordsLayer class];
}

- (instancetype)initWithWordsGeometry:(const mxml::WordsGeometry *)wordsGeometry {
    return [super initWithGeometry:wordsGeometry];
}

- (VMKWordsLayer*)wordsLayer {
    return (VMKWordsLayer*)self.layer;
}

- (const mxml::WordsGeometry*)wordsGeometry {
    return self.wordsLayer.wordsGeometry;
}

- (void)setDirectionGeometry:(const mxml::WordsGeometry *)wordsGeometry {
    self.wordsLayer.wordsGeometry = wordsGeometry;
}

@end
