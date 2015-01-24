//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKPageScoreLayout.h"
#import "VMKGeometry.h"


using namespace mxml;

static const CGFloat VMCursorWidth = 16;


@implementation VMKPageScoreLayout

- (void)setScoreGeometry:(const mxml::PageScoreGeometry*)scoreGeometry {
    _scoreGeometry = scoreGeometry;
    [self invalidateLayout];
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributesArray = [NSMutableArray array];
    if (!_scoreGeometry)
        return attributesArray;

    const auto systemCount = _scoreGeometry->systemGeometries().size();
    for (NSUInteger systemIndex = 0; systemIndex < systemCount; systemIndex += 1) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:systemIndex inSection:0];

        auto systemGeometry = _scoreGeometry->systemGeometries()[systemIndex];
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:systemGeometry atIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attributes.frame))
            [attributesArray addObject:attributes];
    }

    return attributesArray;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
//    if (indexPath.type == VMKScoreElementTypeCursor)
//        return [self layoutAttributesForCursorAtIndexPath:indexPath];

    auto systemGeometry = static_cast<const SystemGeometry*>(_scoreGeometry->systemGeometries()[indexPath.item]);
    return [self layoutAttributesForGeometry:systemGeometry atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForCursorAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.alpha = self.showCursor ? 1 : 0;

    CGRect frame;
    frame.origin.x = self.cursorLocation.x - VMCursorWidth/2;
    frame.origin.y = self.cursorLocation.y;
    frame.size.width = VMCursorWidth;
    frame.size.height = _scoreGeometry->size().height;
    attributes.frame = frame;
    attributes.zIndex = 1;

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForGeometry:(const mxml::Geometry*)geometry atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGRect frame = CGRectFromRect(_scoreGeometry->convertFromGeometry(geometry->frame(), geometry->parentGeometry()));
    frame = VMKRoundRect(frame);
    attributes.frame = frame;

    return attributes;
}

- (CGSize)collectionViewContentSize {
    if (!_scoreGeometry)
        return CGSizeZero;
    return CGSizeMake(_scoreGeometry->size().width, _scoreGeometry->size().height);
}

@end
