// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementContainerView.h"
#import "VMKScoreElementImageLayer.h"


@interface VMKImageView : VMKScoreElementContainerView

- (instancetype)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry;

@end
