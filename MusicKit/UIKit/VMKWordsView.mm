//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
