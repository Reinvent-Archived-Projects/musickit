//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
    self.scoreElementLayer.foregroundColor = foregroundColor.CGColor;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.scoreElementLayer.preferredFrameSize;
}

- (CGSize)intrinsicContentSize {
    return self.scoreElementLayer.preferredFrameSize;
}

@end
