//  Created by Alejandro Isaza on 2014-05-08.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include "ScoreGeometry.h"


@interface VMCollectionViewScoreLayout : UICollectionViewLayout

@property(nonatomic) const mxml::ScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat minHeight;

@property(nonatomic) BOOL showCursor;
@property(nonatomic) CGFloat cursorOffset;

@property(nonatomic, readonly) CGFloat topOffset;

@end
