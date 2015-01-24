//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/SystemGeometry.h>


@interface VMKSystemLayer : VMKScoreElementLayer

- (instancetype)initWithSystemGeometry:(const mxml::SystemGeometry*)systemGeometry;

@property(nonatomic) const mxml::SystemGeometry* systemGeometry;

@end
