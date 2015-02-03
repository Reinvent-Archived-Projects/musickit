//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/PageScoreGeometry.h>

extern NSString* const VMKSystemReuseIdentifier;
extern NSString* const VMKSystemCursorReuseIdentifier;

typedef NS_ENUM(NSUInteger, VMKPageScoreSection) {
    VMKPageScoreSectionSystem,
    VMKPageScoreSectionCursor,
    VMKPageScoreSectionCount
};

@interface VMKPageScoreDataSource : NSObject <UICollectionViewDataSource>

@property(nonatomic) const mxml::PageScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat scale;

@property(nonatomic, strong) NSSet* bookmarks;
@property(nonatomic, strong) UIColor* foregroundColor;
@property(nonatomic, strong) UIColor* tintColor;
@property(nonatomic, strong) UIColor* cursorColor;

@end
