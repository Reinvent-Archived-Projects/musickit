//  Created by Alejandro Isaza on 2014-05-09.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementContainerView.h"
#import "VMScoreElementView.h"
#import "VMDrawing.h"

@implementation VMScoreElementContainerView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.scoreElementView.geometrySize;
    self.scoreElementView.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
