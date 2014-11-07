//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/OrnamentsGeometry.h>


@interface VMKOrnamentLayer : VMKScoreElementImageLayer

+ (NSString*)imageNameForOrnaments:(const mxml::dom::Ornaments&)ornaments;

- (instancetype)initWithOrnamentsGeometry:(const mxml::OrnamentsGeometry*)ornamentsGeometry;

@property(nonatomic) const mxml::OrnamentsGeometry* ornamentsGeometry;

@end
