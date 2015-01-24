//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/ScrollScoreGeometry.h>


@interface VMKCollectionViewScoreLayout : UICollectionViewLayout

@property(nonatomic) const mxml::ScrollScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat minHeight;

@property(nonatomic) BOOL showCursor;
@property(nonatomic) CGFloat cursorOffset;

@property(nonatomic, readonly) CGFloat topOffset;

@end
