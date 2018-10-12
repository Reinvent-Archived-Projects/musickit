// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKPageScoreLayout.h"
#import "VMKGeometry.h"

using namespace mxml;

static const CGFloat kCursorWidth = 16;
static const CGFloat kBottomPadding = 0;

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

- (int)measureIndexForPoint:(CGPoint)point {
    int index = 0;
    
    const auto systemCount = _scoreGeometry->systemGeometries().size();
    for (NSUInteger systemIndex = 0; systemIndex < systemCount; systemIndex += 1) {
        auto systemGeometry = _scoreGeometry->systemGeometries()[systemIndex];
        auto partGeometry = systemGeometry->partGeometries()[0];
        
        const auto measureCount = partGeometry->measureGeometries().size();
        for (NSUInteger measureIndex = 0; measureIndex < measureCount; measureIndex++) {
            auto measureGeometry = partGeometry->measureGeometries()[measureIndex];
            
            CGFloat x = measureGeometry->location().x * self.scale;
            CGFloat y = (measureGeometry->location().y + systemGeometry->location().y) * self.scale;
            CGFloat width = measureGeometry->size().width * self.scale;
            CGFloat height = systemGeometry->size().height * self.scale;
            CGRect measureFrame = CGRectMake(x, y, width, height);
            
            if (CGRectContainsPoint(measureFrame, point)) {
                return index;
            }
                
            index++;
        }
    }
    
    return -1;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributesArray = [NSMutableArray array];
    if (!_scoreGeometry)
        return attributesArray;

    // Header
    if (rect.origin.y < self.headerHeight) {
        [attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    }

    // Systems
    const auto systemCount = _scoreGeometry->systemGeometries().size();
    for (NSUInteger systemIndex = 0; systemIndex < systemCount; systemIndex += 1) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:systemIndex inSection:0];

        auto systemGeometry = _scoreGeometry->systemGeometries()[systemIndex];
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForGeometry:systemGeometry atIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attributes.frame))
            [attributesArray addObject:attributes];
    }

    // Cursors
    if (self.cursorStyle == VMKCursorStyleNote) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [attributesArray addObject:[self layoutAttributesForCursorAtIndexPath:indexPath]];
    } else if (self.cursorStyle == VMKCursorStyleMeasure) {
        [attributesArray addObjectsFromArray:[self layoutAttributesForMeasureCursors]];
    }

    return attributesArray;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0)
        return [self layoutAttributesForCursorAtIndexPath:indexPath];

    if (!_scoreGeometry)
        return nil;

    auto systemGeometry = static_cast<const SystemGeometry*>(_scoreGeometry->systemGeometries()[indexPath.item]);
    return [self layoutAttributesForGeometry:systemGeometry atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForCursorAtIndexPath:(NSIndexPath*)indexPath {
    auto cursorLocation = [self cursorNoteLocation];

    CGRect frame;
    frame.origin.x = cursorLocation.x - kCursorWidth/2;
    frame.origin.y = cursorLocation.y;
    frame.size.width = kCursorWidth;

    std::size_t systemIndex = 0;
    if (_scoreGeometry)
        systemIndex = _scoreGeometry->scoreProperties().systemIndex(_cursorMeasureIndex);

    auto& systemGeometries = _scoreGeometry->systemGeometries();
    if (systemIndex >= systemGeometries.size())
        systemIndex = systemGeometries.size() - 1;
    frame.size.height = systemGeometries.at(systemIndex)->size().height;

    const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
    frame = CGRectApplyAffineTransform(frame, transform);
    frame.origin.y += self.headerHeight;

    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    attributes.alpha = 1;
    attributes.zIndex = 1;

    return attributes;
}

- (NSArray*)layoutAttributesForMeasureCursors {
    NSMutableArray* attributesArray = [NSMutableArray array];
    if (!_scoreGeometry)
        return nullptr;

    const auto& scoreProperties = _scoreGeometry->scoreProperties();
    const auto systemIndex = scoreProperties.systemIndex(_cursorMeasureIndex);
    const auto range = scoreProperties.measureRange(systemIndex);
    const auto systemGeometry = _scoreGeometry->systemGeometries()[systemIndex];

    NSUInteger item = 0;
    for (std::size_t partIndex = 0; partIndex < scoreProperties.partCount(); partIndex += 1) {
        const auto staves = scoreProperties.staves(partIndex);

        auto partGeometry = systemGeometry->partGeometries()[partIndex];
        auto measureGeometry = partGeometry->measureGeometries()[_cursorMeasureIndex - range.first];

        for (int staff = 1; staff <= staves; staff += 1) {
            CGRect frame = CGRectFromRect(partGeometry->convertToGeometry(measureGeometry->frame(), _scoreGeometry));
            frame.origin.y += -measureGeometry->contentOffset().y + partGeometry->staffOrigin(staff);
            frame.size.height = Metrics::staffHeight();

            const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
            frame = CGRectApplyAffineTransform(frame, transform);
            frame.origin.y += self.headerHeight;

            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:1];
            item += 1;

            UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = frame;
            attributes.alpha = 1;
            attributes.zIndex = -1;
            
            [attributesArray addObject:attributes];
        }
    }

    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForGeometry:(const mxml::Geometry*)geometry atIndexPath:(NSIndexPath *)indexPath {
    if (!_scoreGeometry)
        return nil;

    const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
    CGRect frame = CGRectFromRect(_scoreGeometry->convertFromGeometry(geometry->frame(), geometry->parentGeometry()));
    frame = VMKRoundRect(frame);
    frame = CGRectApplyAffineTransform(frame, transform);
    frame.origin.y += self.headerHeight;

    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])
        return nil;

    if (!_scoreGeometry)
        return nil;
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    attributes.frame = CGRectMake(0, 0, _scoreGeometry->size().width * self.scale, self.headerHeight);
    return attributes;
}

- (CGSize)collectionViewContentSize {
    if (!_scoreGeometry)
        return CGSizeZero;

    CGSize size = CGSizeMake(_scoreGeometry->size().width, _scoreGeometry->size().height);
    const CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
    size = CGSizeApplyAffineTransform(size, transform);
    size.height += self.headerHeight + kBottomPadding;
    return size;
}


#pragma mark - Cursor positioning

- (CGPoint)cursorNoteLocation {
    if (!_scoreGeometry)
        return CGPointZero;
    const auto& scoreProperties = _scoreGeometry->scoreProperties();
    const auto& spans = _scoreGeometry->spans();

    auto it = spans.closest(_cursorMeasureIndex, _cursorMeasureTime, typeid(mxml::dom::Note));
    if (it != spans.end()) {
        auto& span = *it;
        auto systemIndex = scoreProperties.systemIndex(span.measureIndex());
        auto range = scoreProperties.measureRange(systemIndex);
        auto systemGeometry = _scoreGeometry->systemGeometries()[systemIndex];

        CGPoint location;
        location.x = span.start() - spans.origin(range.first) + span.eventOffset();
        location.y = systemGeometry->origin().y;
        return location;
    }

    return CGPointFromPoint(_scoreGeometry->origin());
}

@end
