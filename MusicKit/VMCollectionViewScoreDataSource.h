//  Created by Alejandro Isaza on 2014-05-09.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/ScoreGeometry.h>

extern NSString* const kMeasureReuseIdentifier;
extern NSString* const kDirectionReuseIdentifier;
extern NSString* const kTieReuseIdentifier;
extern NSString* const kCursorReuseIdentifier;


@interface VMCollectionViewScoreDataSource : NSObject <UICollectionViewDataSource>

@property(nonatomic) const mxml::ScoreGeometry* scoreGeometry;
@property(nonatomic, strong) NSSet* bookmarks;
@property(nonatomic, strong) UIColor* foregroundColor;
@property(nonatomic, strong) UIColor* tintColor;
@property(nonatomic, strong) UIColor* cursorColor;

@end
