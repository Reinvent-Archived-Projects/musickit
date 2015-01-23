//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "NSIndexPath+VMKScoreAdditions.h"
#import "VMKCollectionViewScoreLayout.h"
#import "VMKCollectionViewScoreDataSource.h"
#import "VMKCursorView.h"
#import "VMKGeometry.h"

#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/PlacementGeometry.h>
#include <mxml/geometry/TieGeometry.h>


using namespace mxml;

static const CGFloat VMCursorWidth = 16;


@implementation VMKCollectionViewScoreLayout {
    CGFloat _topOffset;
}

- (void)setScoreGeometry:(const mxml::ScoreGeometry *)geometry {
    _scoreGeometry = geometry;
    if (_scoreGeometry)
        _topOffset = (_minHeight - _scoreGeometry->size().height)/2;
    [self invalidateLayout];
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributesArray = [NSMutableArray array];
    if (!_scoreGeometry)
        return attributesArray;

    const NSUInteger partCount = _scoreGeometry->geometries().size();
    for (NSUInteger part = 0; part < partCount; part += 1) {
        const PartGeometry* partGeom = static_cast<const PartGeometry*>(_scoreGeometry->geometries().at(part).get());

        const NSUInteger measureCount = partGeom->measureGeometries().size();
        for (NSUInteger i = 0; i < measureCount; i += 1) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i ofType:VMKScoreElementTypeMeasure inPart:part];

            const MeasureGeometry* geometry = partGeom->measureGeometries().at(i);
            UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:geometry atIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame))
                [attributesArray addObject:attributes];
        }
        
        const NSUInteger directionCount = partGeom->directionGeometries().size();
        for (NSUInteger i = 0; i < directionCount; i += 1) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i ofType:VMKScoreElementTypeDirection inPart:part];

            const Geometry* geometry = partGeom->directionGeometries().at(i);
            UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:geometry atIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame))
                [attributesArray addObject:attributes];
        }
        
        const NSUInteger tieCount = partGeom->tieGeometries().size();
        for (NSUInteger i = 0; i < tieCount; i += 1) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i ofType:VMKScoreElementTypeTie inPart:part];

            const TieGeometry* geometry = partGeom->tieGeometries().at(i);
            UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:geometry atIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame))
                [attributesArray addObject:attributes];
        }
    }

    if (self.showCursor && self.cursorOffset >= CGRectGetMinX(rect) && self.cursorOffset <= CGRectGetMaxX(rect)) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 ofType:VMKScoreElementTypeCursor inPart:0];
        [attributesArray addObject:[self layoutAttributesForCursorAtIndexPath:indexPath]];
    }
    
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.type == VMKScoreElementTypeCursor)
        return [self layoutAttributesForCursorAtIndexPath:indexPath];

    const PartGeometry* partGeom = static_cast<const PartGeometry*>(_scoreGeometry->geometries().at(indexPath.part).get());
    const Geometry* geom;
    switch (indexPath.type) {
        case VMKScoreElementTypeMeasure:
            geom = partGeom->measureGeometries().at(indexPath.item);
            break;
        case VMKScoreElementTypeDirection:
            geom = partGeom->directionGeometries().at(indexPath.item);
            break;
        case VMKScoreElementTypeTie:
            geom = partGeom->tieGeometries().at(indexPath.item);
            break;

        default:
            return nil;
    }
    
    return [self layoutAttributesForGeometry:geom atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForCursorAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.alpha = self.showCursor ? 1 : 0;
    
    CGRect frame;
    frame.origin.x = self.cursorOffset - VMCursorWidth/2;
    frame.size.width = VMCursorWidth;
    frame.size.height = _scoreGeometry->size().height + 2*VMCursorFadeOutLength;
    frame.origin.y = _topOffset - VMCursorFadeOutLength;
    attributes.frame = frame;
    attributes.zIndex = 1;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForGeometry:(const mxml::Geometry*)geometry atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGRect frame = CGRectFromRect(_scoreGeometry->convertFromGeometry(geometry->frame(), geometry->parentGeometry()));
    frame.origin.y += _topOffset;
    frame = VMKRoundRect(frame);
    attributes.frame = frame;

    return attributes;
}

- (CGSize)collectionViewContentSize {
    if (!_scoreGeometry)
        return CGSizeZero;
    return CGSizeMake(_scoreGeometry->size().width, std::max(_minHeight, (CGFloat)_scoreGeometry->size().height));
}

@end
