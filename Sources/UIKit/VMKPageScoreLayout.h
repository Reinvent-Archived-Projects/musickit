// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>
#import "VMKCursorView.h"

#include <mxml/geometry/PageScoreGeometry.h>

@interface VMKPageScoreLayout : UICollectionViewLayout

- (int)measureIndexForPoint:(CGPoint)point;

@property(nonatomic) const mxml::PageScoreGeometry* scoreGeometry;

@property(nonatomic) CGFloat scale;
@property(nonatomic) CGFloat headerHeight;

@property(nonatomic) VMKCursorStyle cursorStyle;
@property(nonatomic) std::size_t cursorMeasureIndex;
@property(nonatomic) mxml::dom::time_t cursorMeasureTime;

@property(nonatomic, readonly) CGPoint cursorLocation;

@end
