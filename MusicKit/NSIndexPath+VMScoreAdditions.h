//  Created by Alejandro Isaza on 2014-06-26.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VMScoreElementType) {
    VMScoreElementTypeMeasure = 0,
    VMScoreElementTypeDirection,
    VMScoreElementTypeTie,
    VMScoreElementTypeCursor,
    VMScoreElementTypeCount
};


@interface NSIndexPath (VMScoreAdditions)

+ (NSIndexPath*)indexPathForItem:(NSUInteger)item ofType:(VMScoreElementType)type inPart:(NSUInteger)part;
+ (NSUInteger)numberOfSectionsForPartCount:(NSUInteger)parts;
+ (NSUInteger)partIndexForSection:(NSUInteger)section;
+ (VMScoreElementType)typeForSection:(NSUInteger)section;

@property (nonatomic, readonly) NSUInteger part;
@property (nonatomic, readonly) VMScoreElementType type;

@end
