//  Created by Alejandro Isaza on 2014-05-09.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "NSIndexPath+VMScoreAdditions.h"
#import "VMCollectionViewScoreDataSource.h"
#import "VMCursorView.h"
#import "VMDirectionView.h"
#import "VMEndingView.h"
#import "VMLyricView.h"
#import "VMMeasureView.h"
#import "VMPedalView.h"
#import "VMScoreElementContainerView.h"
#import "VMScoreElementImageView.h"
#import "VMTieView.h"
#import "VMWedgeView.h"

#include "EndingGeometry.h"
#include "LyricGeometry.h"
#include "OrnamentsGeometry.h"
#include "PartGeometry.h"
#include "Pedal.h"
#include "Wedge.h"

NSString* const kMeasureReuseIdentifier = @"Measure";
NSString* const kDirectionReuseIdentifier = @"Direction";
NSString* const kTieReuseIdentifier = @"Tie";
NSString* const kCursorReuseIdentifier = @"Cursor";

using namespace mxml;


@implementation VMCollectionViewScoreDataSource

- (id)init {
    self = [super init];
    self.foregroundColor = [UIColor blackColor];
    return self;
}

- (const PartGeometry*)partGeometryForSection:(NSUInteger)section {
    NSUInteger part = [NSIndexPath partIndexForSection:section];
    const Geometry* geometry = self.scoreGeometry->geometries().at(part).get();
    return static_cast<const PartGeometry*>(geometry);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!self.scoreGeometry)
        return 0;
    return [NSIndexPath numberOfSectionsForPartCount:self.scoreGeometry->geometries().size()];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.scoreGeometry)
        return 0;

    const PartGeometry* partGeom = [self partGeometryForSection:section];
    VMScoreElementType type = [NSIndexPath typeForSection:section];
    if (type == VMScoreElementTypeMeasure)
        return partGeom->measureGeometries().size();
    else if (type == VMScoreElementTypeDirection)
        return partGeom->directionGeometries().size();
    else if (type == VMScoreElementTypeTie)
        return partGeom->tieGeometries().size();
    else if (type == VMScoreElementTypeCursor)
        return 1;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.type == VMScoreElementTypeMeasure)
        return [self collectionView:collectionView cellForMeasureAtIndexPath:indexPath];
    else if (indexPath.type == VMScoreElementTypeDirection)
        return [self collectionView:collectionView cellForDirectionAtIndexPath:indexPath];
    else if (indexPath.type == VMScoreElementTypeTie)
        return [self collectionView:collectionView cellForTieAtIndexPath:indexPath];
    else if (indexPath.type == VMScoreElementTypeCursor)
        return [self collectionView:collectionView cellForCursorAtIndexPath:indexPath];
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForMeasureAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMeasureReuseIdentifier forIndexPath:indexPath];
    
    VMScoreElementContainerView* view = [self scoreElementContainerView:cell];
    if (!view.scoreElementView) {
        view.scoreElementView = [[VMMeasureView alloc] init];
        [view addSubview:view.scoreElementView];
    }

    const PartGeometry* partGeom = [self partGeometryForSection:indexPath.section];
    VMMeasureView* measureView = (VMMeasureView*)view.scoreElementView;
    measureView.foregroundColor = self.foregroundColor;
    measureView.bookmarkedColor = self.tintColor;
    measureView.measureGeometry = partGeom->measureGeometries().at(indexPath.item);
    measureView.bookmarked = [self.bookmarks containsObject:@(indexPath.item)];

    CGRect frame = measureView.frame;
    frame.origin = CGPointZero;
    measureView.frame = frame;

    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForDirectionAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDirectionReuseIdentifier forIndexPath:indexPath];
    
    VMScoreElementContainerView* view = [self scoreElementContainerView:cell];
    if (view.scoreElementView)
        [view.scoreElementView removeFromSuperview];

    const PartGeometry* partGeom = [self partGeometryForSection:indexPath.section];
    const Geometry* geometry = partGeom->directionGeometries().at(indexPath.item);
    if (const SpanDirectionGeometry* geom = dynamic_cast<const SpanDirectionGeometry*>(geometry)) {
        if (dynamic_cast<const dom::Wedge*>(geom->startDirection().type())) {
            view.scoreElementView = [[VMWedgeView alloc] initWithSpanDirectionGeometry:geom];
        } else if (dynamic_cast<const dom::Pedal*>(geom->startDirection().type())) {
            view.scoreElementView = [[VMPedalView alloc] initWithSpanDirectionGeometry:geom];
        }
    } else if (const DirectionGeometry* geom = dynamic_cast<const DirectionGeometry*>(geometry)) {
        view.scoreElementView = [[VMDirectionView alloc] initWithDirectionGeometry:geom];
    } else if (const OrnamentsGeometry* geom = dynamic_cast<const OrnamentsGeometry*>(geometry)) {
        const dom::Ornaments& ornaments = geom->ornaments();
        if (ornaments.trillMark().isPresent()) {
            view.scoreElementView = [[VMScoreElementImageView alloc] initWithImageName:@"trill" geometry:geom];
        } else if (ornaments.turn().isPresent()) {
            view.scoreElementView = [[VMScoreElementImageView alloc] initWithImageName:@"turn" geometry:geom];
        } else if (ornaments.invertedTurn().isPresent()) {
            view.scoreElementView = [[VMScoreElementImageView alloc] initWithImageName:@"inverted-turn" geometry:geom];
        } else if (ornaments.mordent().isPresent()) {
            view.scoreElementView = [[VMScoreElementImageView alloc] initWithImageName:@"mordent" geometry:geom];
        } else if (ornaments.invertedMordent().isPresent()) {
            view.scoreElementView = [[VMScoreElementImageView alloc] initWithImageName:@"inverted-mordent" geometry:geom];
        }
    } else if (const EndingGeometry* geom = dynamic_cast<const EndingGeometry*>(geometry)) {
        view.scoreElementView = [[VMEndingView alloc] initWithEndingGeometry:geom];
    } else if (const LyricGeometry* geom = dynamic_cast<const LyricGeometry*>(geometry)) {
        view.scoreElementView = [[VMLyricView alloc] initWithLyricGeometry:geom];
    }
    
    if (!view.scoreElementView)
        return nil;

    view.scoreElementView.foregroundColor = self.foregroundColor;

    CGRect frame = view.scoreElementView.frame;
    frame.origin = CGPointZero;
    view.scoreElementView.frame = frame;

    [view addSubview:view.scoreElementView];
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForTieAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTieReuseIdentifier forIndexPath:indexPath];
    
    VMScoreElementContainerView* view = [self scoreElementContainerView:cell];
    if (!view.scoreElementView) {
        view.scoreElementView = [[VMTieView alloc] init];
        [view addSubview:view.scoreElementView];
    }

    view.scoreElementView.foregroundColor = self.foregroundColor;

    const PartGeometry* partGeom = [self partGeometryForSection:indexPath.section];
    VMTieView* tieView = (VMTieView*)view.scoreElementView;
    tieView.geometry = partGeom->tieGeometries().at(indexPath.item);

    CGRect frame = tieView.frame;
    frame.origin = CGPointZero;
    tieView.frame = frame;
    
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForCursorAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCursorReuseIdentifier forIndexPath:indexPath];

    VMCursorView* view;
    if (cell.contentView.subviews.count == 0) {
        view = [[VMCursorView alloc] initWithFrame:cell.contentView.bounds];
        [cell.contentView addSubview:view];
    } else {
        view = (VMCursorView*)[cell.contentView.subviews firstObject];
    }
    view.color = self.cursorColor;
    
    return cell;
}

- (VMScoreElementContainerView*)scoreElementContainerView:(UICollectionViewCell*)cell {
    VMScoreElementContainerView* view;
    if (cell.contentView.subviews.count == 0) {
        view = [[VMScoreElementContainerView alloc] initWithFrame:cell.contentView.bounds];
        [cell.contentView addSubview:view];
    } else {
        view = cell.contentView.subviews[0];
    }
    return view;
}

@end
