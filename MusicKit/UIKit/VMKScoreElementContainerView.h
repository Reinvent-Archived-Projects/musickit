//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#import "VMKScoreElementLayer.h"


@interface VMKScoreElementContainerView : UIView

- (instancetype)initWithGeometry:(const mxml::Geometry*)geometry;

@property(nonatomic) const mxml::Geometry* geometry;
@property(nonatomic, strong) VMKScoreElementLayer* scoreElementLayer;
@property(nonatomic, strong) UIColor* foregroundColor;

@end
