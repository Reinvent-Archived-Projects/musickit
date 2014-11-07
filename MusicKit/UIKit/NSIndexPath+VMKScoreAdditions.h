//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
