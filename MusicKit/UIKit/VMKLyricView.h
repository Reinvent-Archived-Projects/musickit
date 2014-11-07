//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKLyricLayer.h"


@interface VMKLyricView : VMKScoreElementContainerView

- (instancetype)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeomerty;

@property(nonatomic) const mxml::LyricGeometry* lyricGeometry;
@property(nonatomic, readonly) VMKLyricLayer* lyricLayer;

@end
