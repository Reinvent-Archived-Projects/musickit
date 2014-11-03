//  Created by Alejandro Isaza on 2014-04-03.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"

@interface VMScoreElementImageView : VMScoreElementView

@property(nonatomic, strong) NSString* imageName;
@property(nonatomic, strong) UIImage* image;
@property(nonatomic, strong) UIImageView* imageView;

- (id)initWithImageName:(NSString*)imageName geometry:(const mxml::Geometry*)geometry;
- (id)initWithImage:(UIImage*)image geometry:(const mxml::Geometry*)geometry;

@end
