//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
