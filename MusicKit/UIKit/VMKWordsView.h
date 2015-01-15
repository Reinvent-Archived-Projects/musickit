//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKWordsLayer.h"


@interface VMKWordsView : VMKScoreElementContainerView

- (instancetype)initWithWordsGeometry:(const mxml::WordsGeometry*)wordsGeom;

@property(nonatomic) const mxml::WordsGeometry* wordsGeometry;
@property(nonatomic, readonly) VMKWordsLayer* wordsLayer;

@end
