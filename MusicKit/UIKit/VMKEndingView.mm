//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKEndingView.h"


@implementation VMKEndingView

+ (Class)layerClass {
    return[VMKEndingLayer class];
}

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeometry {
    return [super initWithGeometry:endingGeometry];
}

- (VMKEndingLayer*)endingLayer {
    return (VMKEndingLayer*)self.layer;
}

- (const mxml::EndingGeometry*)endingGeometry {
    return self.endingLayer.endingGeometry;
}

- (void)setEndingGeometry:(const mxml::EndingGeometry *)endingGeometry {
    self.endingLayer.endingGeometry = endingGeometry;
}

@end
