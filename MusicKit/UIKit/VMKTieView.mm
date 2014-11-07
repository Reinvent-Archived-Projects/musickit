//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKTieView.h"


@implementation VMKTieView

+ (Class)layerClass {
    return[VMKTieLayer class];
}

- (instancetype)initWithTieGeometry:(const mxml::TieGeometry*)tieGeometry {
    return [super initWithGeometry:tieGeometry];
}

- (VMKTieLayer*)directionLayer {
    return (VMKTieLayer*)self.layer;
}

- (const mxml::TieGeometry*)tieGeometry {
    return self.directionLayer.tieGeometry;
}

- (void)setTieGeometry:(const mxml::TieGeometry *)tieGeometry {
    self.directionLayer.tieGeometry = tieGeometry;
}

@end
