//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScrollingOperationQueue.h"

@interface VMKScrollingOperationQueue ()

@property(nonatomic, strong) NSMapTable* operationsByIndex;

@end


@implementation VMKScrollingOperationQueue

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;

    _operationsByIndex = [NSMapTable strongToWeakObjectsMapTable];
    _maxBackwardOperations = 1;
    _maxForwardOperations = 2;
    _scrollingDirection = VMKScrollingDirectionDown;
    _visibleRange = NSMakeRange(0, 1);

    return self;
}

- (NSOperation*)operationForIndex:(NSUInteger)index {
    return [self.operationsByIndex objectForKey:@(index)];
}

- (void)addOperation:(NSOperation *)op forIndex:(NSUInteger)index {
    [super addOperation:op];

    NSOperation* oldOp = [self.operationsByIndex objectForKey:@(index)];
    [oldOp cancel];

    [self.operationsByIndex setObject:op forKey:@(index)];

    // Set operation priority
    if (NSLocationInRange(index, self.visibleRange))
        op.queuePriority = NSOperationQueuePriorityHigh;
    else
        op.queuePriority = NSOperationQueuePriorityNormal;
}

- (void)cancelOutOfRangeOperations {
    NSUInteger start = 0, end = 0;
    if (self.scrollingDirection == VMKScrollingDirectionDown) {
        if (self.visibleRange.location > self.maxBackwardOperations)
            start = self.visibleRange.location - self.maxBackwardOperations;
        end = self.visibleRange.location + self.visibleRange.length + self.maxForwardOperations;
    } else {
        if (self.visibleRange.location > self.maxForwardOperations)
            start = self.visibleRange.location - self.maxForwardOperations;
        end = self.visibleRange.location + self.visibleRange.length + self.maxBackwardOperations;
    }

    NSMutableIndexSet* removeSet = [NSMutableIndexSet indexSet];
    for (NSNumber* indexObject in self.operationsByIndex) {
        NSUInteger index = [indexObject unsignedIntegerValue];
        if (index < start || index >= end) {
            [removeSet addIndex:index];
        } else {
            // Set operation priority
            NSOperation* op = [self.operationsByIndex objectForKey:@(index)];
            if (NSLocationInRange(index, self.visibleRange))
                op.queuePriority = NSOperationQueuePriorityHigh;
            else
                op.queuePriority = NSOperationQueuePriorityLow;
        }
    }

    [removeSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL* stop) {
        NSNumber* key = @(index);
        NSOperation* op = [_operationsByIndex objectForKey:key];
        [_operationsByIndex removeObjectForKey:key];
        [op cancel];
    }];
}

@end
