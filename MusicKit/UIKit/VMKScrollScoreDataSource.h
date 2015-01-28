//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/ScrollScoreGeometry.h>

extern NSString* const VMKMeasureReuseIdentifier;
extern NSString* const VMKDirectionReuseIdentifier;
extern NSString* const VMKTieReuseIdentifier;
extern NSString* const VMKCursorReuseIdentifier;


@interface VMKScrollScoreDataSource : NSObject <UICollectionViewDataSource>

@property(nonatomic) const mxml::ScrollScoreGeometry* scoreGeometry;
@property(nonatomic, strong) NSSet* bookmarks;
@property(nonatomic, strong) UIColor* foregroundColor;
@property(nonatomic, strong) UIColor* tintColor;
@property(nonatomic, strong) UIColor* cursorColor;

@end
