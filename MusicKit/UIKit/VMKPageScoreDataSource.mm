//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import <KVOController/FBKVOController.h>

#import "VMKPageScoreDataSource.h"

#import "VMKCursorView.h"
#import "VMKRenderOperation.h"
#import "VMKScrollingImageCache.h"
#import "VMKScrollingOperationQueue.h"

using namespace mxml;

NSString* const VMKSystemReuseIdentifier = @"System";
NSString* const VMKSystemCursorReuseIdentifier = @"Cursor";
NSString* const VMKPageHeaderReuseIdentifier = @"Header";

static const NSInteger kMaximumConcurrentOperations = 4;


@interface VMKPageScoreDataSource ()

@property(nonatomic, strong) VMKScrollingOperationQueue *queue;
@property(nonatomic, strong) VMKScrollingImageCache *imageCache;
@property(nonatomic, assign) NSInteger previousSystemIndex;
@property(nonatomic, strong) FBKVOController* kvoController;

@end


@implementation VMKPageScoreDataSource

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;

    self.activeForegroundColor = [UIColor blackColor];
    self.inactiveForegroundColor = [UIColor lightGrayColor];
    self.backgroundColor = [UIColor clearColor];
    self.scale = 1;

    self.imageCache = [[VMKScrollingImageCache alloc] init];
    self.imageCache.maxBackwardImages = 1;
    self.imageCache.maxForwardImages = 2;

    self.queue = [[VMKScrollingOperationQueue alloc] init];
    self.queue.maxBackwardOperations = 1;
    self.queue.maxForwardOperations = 2;
    self.queue.name = @"System render queue";
    self.queue.maxConcurrentOperationCount = kMaximumConcurrentOperations;
    if ([self.queue respondsToSelector:@selector(setQualityOfService:)])
        self.queue.qualityOfService = NSQualityOfServiceUtility;

    return self;
}

- (void)setActiveForegroundColor:(UIColor *)activeForegroundColor {
    _activeForegroundColor = activeForegroundColor;
    [self.imageCache removeAllImages];
}

- (void)setInactiveForegroundColor:(UIColor *)inactiveForegroundColor {
    _inactiveForegroundColor = inactiveForegroundColor;
    [self.imageCache removeAllImages];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self.imageCache removeAllImages];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    if (!self.kvoController) {
        self.kvoController = [FBKVOController controllerWithObserver:self];
        [self.kvoController observe:collectionView keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(VMKPageScoreDataSource* observer, UICollectionView* collectionView, NSDictionary* change) {
            CGPoint from = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGPoint to = [change[NSKeyValueChangeNewKey] CGPointValue];
            [observer collectionView:collectionView didScrollFrom:from to:to];
        }];
    }

    if (!self.scoreGeometry)
        return 0;

    switch (self.cursorStyle) {
        case VMKCursorStyleNone:
            return 1;

        case VMKCursorStyleNote:
        case VMKCursorStyleMeasure:
            return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == VMKPageScoreSectionSystem)
        return _scoreGeometry->systemGeometries().size();
    else if (section == VMKPageScoreSectionCursor && self.cursorStyle == VMKCursorStyleNote)
        return 1;
    else
        return static_cast<NSInteger>(self.scoreGeometry->scoreProperties().staves());
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == VMKPageScoreSectionSystem)
        return [self collectionView:collectionView cellForSystemAtIndexPath:indexPath];
    else if (indexPath.section == VMKPageScoreSectionCursor)
        return [self collectionView:collectionView cellForCursorAtIndexPath:indexPath];
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForSystemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:VMKSystemReuseIdentifier forIndexPath:indexPath];

    NSInteger systemIndex = indexPath.item;
    UIImage* image = [_imageCache imageForIndex:systemIndex];
    UIImageView* systemImageView = [self imageViewForCell:cell];
    systemImageView.image = image;

    if (!image && [_queue operationForIndex:systemIndex] == nil) {
        [self collectionView:collectionView prefetchSystemImage:systemIndex];
    }

    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForCursorAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:VMKSystemCursorReuseIdentifier forIndexPath:indexPath];
    
    VMKCursorView* view;
    if (cell.contentView.subviews.count == 0) {
        view = [[VMKCursorView alloc] initWithFrame:cell.contentView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:view];
    } else {
        view = (VMKCursorView*)[cell.contentView.subviews firstObject];
    }
    view.opacity = self.cursorOpacity;
    view.cursorStyle = self.cursorStyle;
    view.color = self.cursorColor;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:VMKPageHeaderReuseIdentifier forIndexPath:indexPath];
    return view;
}

- (UIImageView*)collectionView:(UICollectionView *)collectionView imageViewForCellAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:VMKPageScoreSectionSystem];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    return [self imageViewForCell:cell];
}

- (UIImageView*)imageViewForCell:(UICollectionViewCell*)cell {
    if (!cell)
        return nil;

    UIImageView *imageView;
    if (cell.contentView.subviews.count > 0) {
        imageView = (UIImageView*)cell.contentView.subviews[0];
        imageView.frame = cell.contentView.bounds;
    } else {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        [cell.contentView addSubview:imageView];
    }

    return imageView;
}

- (void)collectionView:(UICollectionView*)collectionView didScrollFrom:(CGPoint)from to:(CGPoint)to {
    VMKScrollingDirection direction;
    if (from.y <= to.y)
        direction = VMKScrollingDirectionDown;
    else
        direction = VMKScrollingDirectionUp;

    NSArray* visibleItems = [collectionView indexPathsForVisibleItems];
    if (visibleItems.count <= 1)
        return;

    NSRange visibleRange = NSMakeRange(0, 0);
    for (NSIndexPath* indexPath in visibleItems) {
        if (indexPath.section != 0)
            continue;

        NSUInteger index = indexPath.item;
        if (visibleRange.length == 0) {
            visibleRange.location = index;
            visibleRange.length = 1;
        } else if (index < visibleRange.location) {
            NSInteger delta = visibleRange.location - index;
            visibleRange.location = index;
            visibleRange.length += delta;
        } else if (index > NSMaxRange(visibleRange)) {
            NSInteger delta = index - NSMaxRange(visibleRange);
            visibleRange.length += delta;
        }
    }

    _imageCache.scrollingDirection = direction;
    _imageCache.visibleRange = visibleRange;
    [_imageCache removeOutOfRangeImages];

    _queue.scrollingDirection = direction;
    _queue.visibleRange = visibleRange;
    [_queue cancelOutOfRangeOperations];
}


#pragma mark - Cell Prefetching

- (void)collectionView:(UICollectionView *)collectionView prefetchSystemImage:(NSInteger)index {
    auto systemGeometry = self.scoreGeometry->systemGeometries().at(index);
    VMKRenderOperation* op = [VMKRenderOperation operationForSystemGeometry:systemGeometry];
    op.activeForegroundColor = self.activeForegroundColor;
    op.inactiveForegroundColor = self.inactiveForegroundColor;
    op.backgroundColor = self.backgroundColor;

    __weak VMKRenderOperation* wop = op;
    op.completionBlock = ^() {
        UIImage* image = wop.image;
        if (!image)
            return;

        [_imageCache addImage:image forIndex:index];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImageView* systemImageView = [self collectionView:collectionView imageViewForCellAtIndex:index];
            [systemImageView setImage:image];
        }];
    };

    [_queue addOperation:op forIndex:index];
}

@end
