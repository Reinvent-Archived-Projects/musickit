//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#include <mxml/geometry/SystemGeometry.h>


@interface VMKSystemView : VMKScoreElementContainerView

- (instancetype)initWithSystemGeometry:(const mxml::SystemGeometry*)systemGeometry;

@property(nonatomic) const mxml::SystemGeometry* systemGeometry;

@end
