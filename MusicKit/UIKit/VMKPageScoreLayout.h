//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#import "VMKCursorView.h"

#include <mxml/geometry/PageScoreGeometry.h>


@interface VMKPageScoreLayout : UICollectionViewLayout

@property(nonatomic) const mxml::PageScoreGeometry* scoreGeometry;

@property(nonatomic) CGFloat scale;
@property(nonatomic) CGFloat headerHeight;

@property(nonatomic) VMKCursorStyle cursorStyle;
@property(nonatomic) std::size_t cursorMeasureIndex;
@property(nonatomic) mxml::dom::time_t cursorMeasureTime;

@property(nonatomic, readonly) CGPoint cursorLocation;

@end
