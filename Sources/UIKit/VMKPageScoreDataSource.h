// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>
#import "VMKCursorView.h"

#include <mxml/geometry/PageScoreGeometry.h>

extern NSString* const VMKSystemReuseIdentifier;
extern NSString* const VMKSystemCursorReuseIdentifier;
extern NSString* const VMKPageHeaderReuseIdentifier;

typedef NS_ENUM(NSUInteger, VMKPageScoreSection) {
    VMKPageScoreSectionSystem,
    VMKPageScoreSectionCursor
};

@interface VMKPageScoreDataSource : NSObject <UICollectionViewDataSource>

@property(nonatomic) const mxml::PageScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat scale;
@property(nonatomic) CGFloat cursorOpacity;
@property(nonatomic) VMKCursorStyle cursorStyle;

@property(nonatomic, strong) NSArray* noteColors;
@property(nonatomic, strong) UIColor* foregroundColor;
@property(nonatomic, strong) UIColor* tintColor;
@property(nonatomic, strong) UIColor* cursorColor;

@end
