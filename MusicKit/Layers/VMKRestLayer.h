//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementImageLayer.h"
#include <mxml/geometry/RestGeometry.h>


@interface VMKRestLayer : VMKScoreElementImageLayer

+ (NSString*)headImageNameForType:(mxml::dom::Optional<mxml::dom::Note::Type>)type;

- (instancetype)initWithRestGeometry:(const mxml::RestGeometry*)restGeom;

@property(nonatomic) const mxml::RestGeometry*restGeometry;

@end
