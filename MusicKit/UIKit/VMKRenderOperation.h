//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKColor.h"
#import "VMKImage.h"
#include <mxml/geometry/SystemGeometry.h>


@interface VMKRenderOperation : NSOperation

@property(nonatomic) const mxml::SystemGeometry* systemGeometry;
@property(nonatomic, strong) VMKColor* activeForegroundColor;
@property(nonatomic, strong) VMKColor* inactiveForegroundColor;
@property(nonatomic, strong) VMKColor* backgroundColor;
@property(nonatomic, strong) VMKImage* image;

+ (instancetype)operationForSystemGeometry:(const mxml::SystemGeometry*)systemGeometry;

@end
