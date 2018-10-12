// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>
#import "VMKCursorView.h"

#include <mxml/geometry/ScrollScoreGeometry.h>

@interface VMKScrollScoreLayout : UICollectionViewLayout

- (NSArray*)noteTimeForPoint:(CGPoint)point withScale:(CGFloat)scale;
- (CGPoint)pointForMeasureIndex:(int)measureIndex measureTime:(float)measureTime;

@property(nonatomic) const mxml::ScrollScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat minHeight;

@property(nonatomic) VMKCursorStyle cursorStyle;
@property(nonatomic) std::size_t cursorMeasureIndex;
@property(nonatomic) mxml::dom::time_t cursorMeasureTime;

@property(nonatomic, readonly) CGFloat topOffset;
@property(nonatomic, readonly) CGFloat cursorLocation;

@end
