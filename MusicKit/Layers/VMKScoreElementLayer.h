//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "VMKColor.h"

#include <mxml/geometry/Geometry.h>


@interface VMKScoreElementLayer : CALayer

/** Designated initializer. */
- (instancetype)initWithGeometry:(const mxml::Geometry*)geometry;

/** Geometry object. */
@property(nonatomic) const mxml::Geometry* geometry;

/** The foreground color. */
@property(nonatomic, strong) VMKColor* foregroundColor;


/** This method is called from init to setup the view.

 Implementing all possible init methods for a view is cumbersome and prone to error. Instead all subclasses should put
 their setup code in this method. Don't forget to call super's implementation.
 */
- (void)setup;


@end
