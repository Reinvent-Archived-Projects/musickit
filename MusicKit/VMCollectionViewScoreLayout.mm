//  Created by Alejandro Isaza on 2014-05-08.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "NSIndexPath+VMScoreAdditions.h"
#import "VMCollectionViewScoreLayout.h"
#import "VMCollectionViewScoreDataSource.h"
#import "VMCursorView.h"
#import "VMDrawing.h"

#include "PartGeometry.h"

using namespace mxml;

static const CGFloat VMCursorWidth = 16;


@implementation VMCollectionViewScoreLayout {
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
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i ofType:VMScoreElementTypeMeasure inPart:part];

            const MeasureGeometry* geometry = partGeom->measureGeometries().at(i);
            UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:geometry atIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame))
                [attributesArray addObject:attributes];
        }
        
        const NSUInteger directionCount = partGeom->directionGeometries().size();
        for (NSUInteger i = 0; i < directionCount; i += 1) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i ofType:VMScoreElementTypeDirection inPart:part];

            const Geometry* geometry = partGeom->directionGeometries().at(i);
            UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:geometry atIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame))
                [attributesArray addObject:attributes];
        }
        
        const NSUInteger tieCount = partGeom->tieGeometries().size();
        for (NSUInteger i = 0; i < tieCount; i += 1) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i ofType:VMScoreElementTypeTie inPart:part];

            const TieGeometry* geometry = partGeom->tieGeometries().at(i);
            UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:geometry atIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame))
                [attributesArray addObject:attributes];
        }
    }

    if (self.showCursor && self.cursorOffset >= CGRectGetMinX(rect) && self.cursorOffset <= CGRectGetMaxX(rect)) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 ofType:VMScoreElementTypeCursor inPart:0];
        [attributesArray addObject:[self layoutAttributesForCursorAtIndexPath:indexPath]];
    }
    
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.type == VMScoreElementTypeCursor)
        return [self layoutAttributesForCursorAtIndexPath:indexPath];

    const PartGeometry* partGeom = static_cast<const PartGeometry*>(_scoreGeometry->geometries().at(indexPath.part).get());
    const Geometry* geom;
    switch (indexPath.type) {
        case VMScoreElementTypeMeasure:
            geom = partGeom->measureGeometries().at(indexPath.item);
            break;
        case VMScoreElementTypeDirection:
            geom = partGeom->directionGeometries().at(indexPath.item);
            break;
        case VMScoreElementTypeTie:
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
    frame = VMRoundRect(frame);
    attributes.frame = frame;

    return attributes;
}

- (CGSize)collectionViewContentSize {
    if (!_scoreGeometry)
        return CGSizeZero;
    return CGSizeMake(_scoreGeometry->size().width, std::max(_minHeight, (CGFloat)_scoreGeometry->size().height));
}

@end
