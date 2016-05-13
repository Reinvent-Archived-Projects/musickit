// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKPedalView.h"


@implementation VMKPedalView

+ (Class)layerClass {
    return[VMKPedalLayer class];
}

- (instancetype)initWithPedalGeometry:(const mxml::SpanDirectionGeometry *)pedalGeometry {
    return [super initWithGeometry:pedalGeometry];
}

- (VMKPedalLayer*)pedalLayer {
    return (VMKPedalLayer*)self.layer;
}

- (const mxml::SpanDirectionGeometry*)pedalGeometry {
    return self.pedalLayer.spanDirectionGeometry;
}

- (void)setSpanDirectionGeometry:(const mxml::SpanDirectionGeometry *)pedalGeometry {
    self.pedalLayer.spanDirectionGeometry = pedalGeometry;
}

@end
