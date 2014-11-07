//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
