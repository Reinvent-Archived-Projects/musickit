//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import <Foundation/Foundation.h>
#import "VMKImage.h"
#import "VMKScrollingDirection.h"


@interface VMKScrollingImageCache : NSObject

/**
 The number of images to keep for invisible indices in the direction opposite to scrolling.
 */
@property NSInteger maxBackwardImages;

/**
 The number of images to keep for invisible indices in the scrolling directions.
 */
@property NSInteger maxForwardImages;

/**
 The current scrolling directions
 */
@property VMKScrollingDirection scrollingDirection;

/**
 The current visible range.
 */
@property NSRange visibleRange;

- (VMKImage*)imageForIndex:(NSUInteger)index;
- (void)addImage:(VMKImage*)image forIndex:(NSUInteger)index;

- (void)removeOutOfRangeImages;
- (void)removeAllImages;

@end
