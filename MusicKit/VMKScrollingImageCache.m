//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKScrollingImageCache.h"


@interface VMKScrollingImageCache ()

@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) NSMutableDictionary* imagesByIndex;

@end


@implementation VMKScrollingImageCache

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;

    _queue = dispatch_queue_create("VMKScrollingImageCache", DISPATCH_QUEUE_SERIAL);
    _imagesByIndex = [NSMutableDictionary dictionary];
    _maxBackwardImages = 1;
    _maxForwardImages = 2;
    _scrollingDirection = VMKScrollingDirectionDown;
    _visibleRange = NSMakeRange(0, 1);

    return self;
}

- (VMKImage*)imageForIndex:(NSUInteger)index {
    __block VMKImage* image;
    dispatch_sync(_queue, ^() {
        image = _imagesByIndex[@(index)];
    });
    return image;
}

- (void)addImage:(VMKImage*)image forIndex:(NSUInteger)index {
    dispatch_async(_queue, ^() {
        if (NSLocationInRange(index, [self preserveRange]))
            _imagesByIndex[@(index)] = image;
    });
}

- (void)removeOutOfRangeImages {
    dispatch_async(_queue, ^() {
        [self _removeOutOfRangeImages];
    });
}

- (NSRange)preserveRange {
    NSRange range = NSMakeRange(0, 0);

    if (self.scrollingDirection == VMKScrollingDirectionDown) {
        if (self.visibleRange.location > self.maxBackwardImages)
            range.location = self.visibleRange.location - self.maxBackwardImages;
        NSUInteger end = self.visibleRange.location + self.visibleRange.length + self.maxForwardImages;
        range.length = end - range.location;
    } else {
        if (self.visibleRange.location > self.maxForwardImages)
            range.location = self.visibleRange.location - self.maxForwardImages;
        NSUInteger end = self.visibleRange.location + self.visibleRange.length + self.maxBackwardImages;
        range.length = end - range.location;
    }

    return range;
}

- (void)_removeOutOfRangeImages {
    NSRange range = [self preserveRange];

    NSMutableIndexSet* removeSet = [NSMutableIndexSet indexSet];
    for (NSNumber* indexObject in _imagesByIndex) {
        NSUInteger index = [indexObject unsignedIntegerValue];
        if (!NSLocationInRange(index, range)) {
            [removeSet addIndex:index];
        }
    }

    [removeSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL* stop) {
        [_imagesByIndex removeObjectForKey:@(index)];
    }];
}

- (void)removeAllImages {
    [_imagesByIndex removeAllObjects];
}

@end
