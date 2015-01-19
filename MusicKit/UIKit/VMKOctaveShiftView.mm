//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

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
