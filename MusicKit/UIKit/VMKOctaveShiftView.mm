// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKOctaveShiftView.h"

@implementation VMKOctaveShiftView

+ (Class)layerClass {
    return[VMKOctaveShiftLayer class];
}

- (instancetype)initWithOctaveShiftGeometry:(const mxml::SpanDirectionGeometry *)pedalGeometry {
    return [super initWithGeometry:pedalGeometry];
}

- (VMKOctaveShiftLayer*)octaveShiftLayer {
    return (VMKOctaveShiftLayer*)self.layer;
}

- (const mxml::SpanDirectionGeometry*)pedalGeometry {
    return self.octaveShiftLayer.spanDirectionGeometry;
}

- (void)setSpanDirectionGeometry:(const mxml::SpanDirectionGeometry *)octaveShiftGeometry {
    self.octaveShiftLayer.spanDirectionGeometry = octaveShiftGeometry;
}

@end
