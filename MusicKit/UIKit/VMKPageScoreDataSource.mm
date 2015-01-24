//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKPageScoreDataSource.h"
#import "VMKSystemView.h"

using namespace mxml;

NSString* const VMKSystemReuseIdentifier = @"System";


@implementation VMKPageScoreDataSource

- (instancetype)init {
    self = [super init];
    self.foregroundColor = [UIColor blackColor];
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.scoreGeometry)
        return 0;
    return _scoreGeometry->systemGeometries().size();
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:VMKSystemReuseIdentifier forIndexPath:indexPath];

    VMKSystemView* systemView;
    if (cell.contentView.subviews.count > 0) {
        systemView = (VMKSystemView*)cell.contentView.subviews[0];
    } else {
        systemView = [[VMKSystemView alloc] init];
        [cell.contentView addSubview:systemView];
    }

    const SystemGeometry* systemGeometry = _scoreGeometry->systemGeometries()[indexPath.item];
    systemView.foregroundColor = self.foregroundColor;
    systemView.systemGeometry = systemGeometry;

    CGRect frame = systemView.frame;
    frame.origin = CGPointZero;
    systemView.frame = frame;

    return cell;
}

@end
