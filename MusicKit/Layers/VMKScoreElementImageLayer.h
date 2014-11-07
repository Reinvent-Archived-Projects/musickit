//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementLayer.h"
#import "VMKImage.h"


@interface VMKScoreElementImageLayer : VMKScoreElementLayer

@property(nonatomic, strong) NSString* imageName;
@property(nonatomic, strong) VMKImage* image;

- (instancetype)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry;
- (instancetype)initWithImage:(VMKImage*)image geometry:(const mxml::Geometry*)geometry;

@end
