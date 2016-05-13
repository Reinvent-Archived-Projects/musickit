// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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
