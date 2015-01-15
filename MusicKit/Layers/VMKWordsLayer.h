//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/WordsGeometry.h>


@interface VMKWordsLayer : VMKScoreElementLayer

- (instancetype)initWithWordsGeometry:(const mxml::WordsGeometry*)wordsGeom;

@property(nonatomic) const mxml::WordsGeometry* wordsGeometry;
@property(nonatomic, strong) CATextLayer* textLayer;

@end
