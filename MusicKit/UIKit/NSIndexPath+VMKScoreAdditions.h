// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VMKScoreElementType) {
    VMKScoreElementTypeMeasure = 0,
    VMKScoreElementTypeDirection,
    VMKScoreElementTypeTie,
    VMKScoreElementTypeCursor,
    VMKScoreElementTypeCount
};


@interface NSIndexPath (VMKScoreAdditions)

+ (NSIndexPath*)indexPathForItem:(NSUInteger)item ofType:(VMKScoreElementType)type inPart:(NSUInteger)part;
+ (NSUInteger)numberOfSectionsForPartCount:(NSUInteger)parts;
+ (NSUInteger)partIndexForSection:(NSUInteger)section;
+ (VMKScoreElementType)typeForSection:(NSUInteger)section;

@property (nonatomic, readonly) NSUInteger part;
@property (nonatomic, readonly) VMKScoreElementType type;

@end
