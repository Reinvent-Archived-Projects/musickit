//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#import <mxml/geometry/LyricGeometry.h>


@interface VMKLyricLayer : VMKScoreElementLayer

- (instancetype)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry;

@property(nonatomic) const mxml::LyricGeometry* lyricGeometry;

@property(nonatomic, strong) CATextLayer* textLayer;

@end
