//  Created by Alejandro Isaza on 2014-07-22.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "LyricGeometry.h"

@interface VMLyricView : VMScoreElementView

- (id)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry;

@property(nonatomic) const mxml::LyricGeometry* lyricGeometry;

@property(nonatomic, strong) UILabel* label;

@end
