// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKWedgeView.h"


@implementation VMKWedgeView

+ (Class)layerClass {
    return[VMKWedgeLayer class];
}

- (instancetype)initWithWedgeGeometry:(const mxml::SpanDirectionGeometry *)wedgeGeometry {
    return [super initWithGeometry:wedgeGeometry];
}

- (VMKWedgeLayer*)wedgeLayer {
    return (VMKWedgeLayer*)self.layer;
}

- (const mxml::SpanDirectionGeometry*)wedgeGeometry {
    return self.wedgeLayer.spanDirectionGeometry;
}

- (void)setSpanDirectionGeometry:(const mxml::SpanDirectionGeometry *)wedgeGeometry {
    self.wedgeLayer.spanDirectionGeometry = wedgeGeometry;
}

@end
