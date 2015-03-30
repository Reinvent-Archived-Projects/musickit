//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#import "VMKCursorView.h"

#include <mxml/geometry/ScrollScoreGeometry.h>


@interface VMKScrollScoreLayout : UICollectionViewLayout

@property(nonatomic) const mxml::ScrollScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat minHeight;

@property(nonatomic) VMKCursorStyle cursorStyle;
@property(nonatomic) std::size_t cursorMeasureIndex;
@property(nonatomic) mxml::dom::time_t cursorMeasureTime;

@property(nonatomic, readonly) CGFloat topOffset;
@property(nonatomic, readonly) CGFloat cursorLocation;

@end
