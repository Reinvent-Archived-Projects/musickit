// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementContainerView.h"


@implementation VMKScoreElementContainerView

+ (Class)layerClass {
    return[VMKScoreElementLayer class];
}

- (instancetype)initWithGeometry:(const mxml::Geometry*)geometry {
    self = [super init];
    self.geometry = geometry;
    return self;
}

- (VMKScoreElementLayer*)scoreElementLayer {
    return (VMKScoreElementLayer*)self.layer;
}

- (const mxml::Geometry*)geometry {
    return self.scoreElementLayer.geometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    self.scoreElementLayer.geometry = geometry;
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    self.scoreElementLayer.activeForegroundColor = foregroundColor;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.scoreElementLayer.preferredFrameSize;
}

- (CGSize)intrinsicContentSize {
    return self.scoreElementLayer.preferredFrameSize;
}

@end
