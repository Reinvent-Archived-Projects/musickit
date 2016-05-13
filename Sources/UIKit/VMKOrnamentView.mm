// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKOrnamentView.h"

@implementation VMKOrnamentView

+ (Class)layerClass {
    return [VMKOrnamentLayer class];
}

- (instancetype)initWithOrnamentsGeometry:(const mxml::OrnamentsGeometry*)ornamentsGeometry {
    return [super initWithGeometry:ornamentsGeometry];
}

- (VMKOrnamentLayer*)ornamentLayer {
    return (VMKOrnamentLayer*)self.layer;
}

- (const mxml::OrnamentsGeometry*)ornamentsGeometry {
    return self.ornamentLayer.ornamentsGeometry;
}

- (void)setOrnamentsGeometry:(const mxml::OrnamentsGeometry *)ornamentsGeometry {
    self.ornamentLayer.ornamentsGeometry = ornamentsGeometry;
}

@end
