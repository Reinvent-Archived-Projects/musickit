// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>
#import "VMKCursorView.h"

#include <mxml/geometry/ScrollScoreGeometry.h>

extern NSString* const VMKMeasureReuseIdentifier;
extern NSString* const VMKDirectionReuseIdentifier;
extern NSString* const VMKTieReuseIdentifier;
extern NSString* const VMKCursorReuseIdentifier;


@interface VMKScrollScoreDataSource : NSObject <UICollectionViewDataSource>

@property(nonatomic) const mxml::ScrollScoreGeometry* scoreGeometry;
@property(nonatomic) CGFloat cursorOpacity;
@property(nonatomic) VMKCursorStyle cursorStyle;

@property(nonatomic, strong) UIColor* foregroundColor;
@property(nonatomic, strong) UIColor* tintColor;
@property(nonatomic, strong) UIColor* cursorColor;

@end
 