// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#import "VMKImage.h"


@interface VMKScoreElementImageLayer : VMKScoreElementLayer

@property(nonatomic, strong) NSString* imageName;
@property(nonatomic, strong) VMKImage* image;

- (instancetype)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry;
- (instancetype)initWithImage:(VMKImage*)image geometry:(const mxml::Geometry*)geometry;

@end
