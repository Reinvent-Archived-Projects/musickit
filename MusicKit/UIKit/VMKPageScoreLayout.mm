//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKPageScoreLayout.h"
#import "VMKGeometry.h"


using namespace mxml;

static const CGFloat VMCursorWidth = 16;


@implementation VMKPageScoreLayout

- (instancetype)init {
    self = [super init];
    self.scale = 1;
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)decoder {
    self = [super initWithCoder:decoder];
    self.scale = 1;
    return self;
}

- (void)setScoreGeometry:(const mxml::PageScoreGeometry*)scoreGeometry {
    _scoreGeometry = scoreGeometry;
    [self invalidateLayout];
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributesArray = [NSMutableArray array];
    if (!_scoreGeometry)
        return attributesArray;

    const auto transform = CGAffineTransformMakeScale(self.scale, self.scale);
    const auto systemCount = _scoreGeometry->systemGeometries().size();
    for (NSUInteger systemIndex = 0; systemIndex < systemCount; systemIndex += 1) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:systemIndex inSection:0];

        auto systemGeometry = _scoreGeometry->systemGeometries()[systemIndex];
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:systemGeometry atIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attributes.frame))
            [attributesArray addObject:attributes];
    }
    
    if (self.showCursor && CGRectContainsPoint(rect, CGPointApplyAffineTransform(self.cursorLocation, transform))) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [attributesArray addObject:[self layoutAttributesForCursorAtIndexPath:indexPath]];
    }

    return attributesArray;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0)
        return [self layoutAttributesForCursorAtIndexPath:indexPath];

    auto systemGeometry = static_cast<const SystemGeometry*>(_scoreGeometry->systemGeometries()[indexPath.item]);
    return [self layoutAttributesForGeometry:systemGeometry atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForCursorAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    frame.origin.x = self.cursorLocation.x - VMCursorWidth/2;
    frame.origin.y = self.cursorLocation.y;
    frame.size.width = VMCursorWidth;

    auto& systemGeometries = _scoreGeometry->systemGeometries();
    if (_cursorSystemIndex >= systemGeometries.size())
        _cursorSystemIndex = systemGeometries.size() - 1;
    frame.size.height = systemGeometries.at(_cursorSystemIndex)->size().height;

    const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
    attributes.frame = CGRectApplyAffineTransform(frame, transform);
    attributes.alpha = self.showCursor ? 1 : 0;
    attributes.zIndex = 1;

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForGeometry:(const mxml::Geometry*)geometry atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
    CGRect frame = CGRectFromRect(_scoreGeometry->convertFromGeometry(geometry->frame(), geometry->parentGeometry()));
    frame = VMKRoundRect(frame);
    attributes.frame = CGRectApplyAffineTransform(frame, transform);

    return attributes;
}

- (CGSize)collectionViewContentSize {
    if (!_scoreGeometry)
        return CGSizeZero;

    const CGSize size = CGSizeMake(_scoreGeometry->size().width, _scoreGeometry->size().height);
    const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
    return CGSizeApplyAffineTransform(size, transform);
}

@end
