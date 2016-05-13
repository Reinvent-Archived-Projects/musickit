// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <QuartzCore/QuartzCore.h>
#import "VMKColor.h"

#include <mxml/geometry/Geometry.h>


@interface VMKScoreElementLayer : CALayer

/** Designated initializer. */
- (instancetype)initWithGeometry:(const mxml::Geometry*)geometry;

/** Geometry object. */
@property(nonatomic) const mxml::Geometry* geometry;

/** The active foreground color. */
@property(nonatomic, strong) VMKColor* activeForegroundColor;

/** The inactive foreground color. */
@property(nonatomic, strong) VMKColor* inactiveForegroundColor;

/** The current foreground color. */
@property(nonatomic, strong, readonly) VMKColor* foregroundColor;


/** This method is called from init to setup the view.

 Implementing all possible init methods for a view is cumbersome and prone to error. Instead all subclasses should put
 their setup code in this method. Don't forget to call super's implementation.
 */
- (void)setup;


@end
