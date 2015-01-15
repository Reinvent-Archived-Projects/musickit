//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKScoreElementImageLayer.h"


@interface VMKImageView : VMKScoreElementContainerView

- (instancetype)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry;

@end
