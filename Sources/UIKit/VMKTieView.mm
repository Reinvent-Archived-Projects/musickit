// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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
