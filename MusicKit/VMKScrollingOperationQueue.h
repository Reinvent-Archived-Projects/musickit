//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import <Foundation/Foundation.h>
#import "VMKScrollingDirection.h"


@interface VMKScrollingOperationQueue : NSOperationQueue

/**
 The number of operations to keep for invisible indices in the direction opposite to scrolling.
 */
@property NSInteger maxBackwardOperations;

/**
 The number of operations to keep for invisible indices in the scrolling directions.
 */
@property NSInteger maxForwardOperations;

/**
 The current scrolling directions
 */
@property VMKScrollingDirection scrollingDirection;

/**
 The current visible range.
 */
@property NSRange visibleRange;

- (NSOperation*)operationForIndex:(NSUInteger)index;
- (void)addOperation:(NSOperation *)op forIndex:(NSUInteger)index;

- (void)cancelOutOfRangeOperations;

@end
