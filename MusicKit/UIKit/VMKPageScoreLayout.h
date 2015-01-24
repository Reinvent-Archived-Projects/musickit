//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/PageScoreGeometry.h>


@interface VMKPageScoreLayout : UICollectionViewLayout

@property(nonatomic) const mxml::PageScoreGeometry* scoreGeometry;

@property(nonatomic) BOOL showCursor;
@property(nonatomic) CGPoint cursorLocation;

@end
