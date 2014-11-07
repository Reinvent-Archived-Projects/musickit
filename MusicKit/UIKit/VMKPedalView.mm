//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
