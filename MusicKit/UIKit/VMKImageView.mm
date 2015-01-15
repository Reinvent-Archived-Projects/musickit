//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#include "VMKImageView.h"

@implementation VMKImageView

+ (Class)layerClass {
    return [VMKScoreElementImageLayer class];
}

- (VMKScoreElementImageLayer*)imageLayer {
    return (VMKScoreElementImageLayer*)self.layer;
}

- (instancetype)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry {
    self = [super initWithGeometry:geometry];
    if (!self)
        return nil;
    
    self.imageLayer.imageName = imageName;
    self.imageLayer.geometry = geometry;
    return self;
}

@end
