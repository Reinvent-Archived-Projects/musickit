//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/ScoreGeometry.h>


@interface VMKCollectionViewScoreLayout : UICollectionViewLayout

@property(nonatomic) const mxml::ScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat minHeight;

@property(nonatomic) BOOL showCursor;
@property(nonatomic) CGFloat cursorOffset;

@property(nonatomic, readonly) CGFloat topOffset;

@end
