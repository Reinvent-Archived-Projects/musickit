//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKDirectionView.h"


@implementation VMKDirectionView

+ (Class)layerClass {
    return[VMKDirectionLayer class];
}

- (instancetype)initWithDirectionGeometry:(const mxml::DirectionGeometry *)directionGeometry {
    return [super initWithGeometry:directionGeometry];
}

- (VMKDirectionLayer*)directionLayer {
    return (VMKDirectionLayer*)self.layer;
}

- (const mxml::DirectionGeometry*)directionGeometry {
    return self.directionLayer.directionGeometry;
}

- (void)setDirectionGeometry:(const mxml::DirectionGeometry *)directionGeometry {
    self.directionLayer.directionGeometry = directionGeometry;
}

@end
