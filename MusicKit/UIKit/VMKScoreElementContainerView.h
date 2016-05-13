// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>
#import "VMKScoreElementLayer.h"


@interface VMKScoreElementContainerView : UIView

- (instancetype)initWithGeometry:(const mxml::Geometry*)geometry;

@property(nonatomic) const mxml::Geometry* geometry;
@property(nonatomic, strong) VMKScoreElementLayer* scoreElementLayer;
@property(nonatomic, strong) UIColor* foregroundColor;

@end
