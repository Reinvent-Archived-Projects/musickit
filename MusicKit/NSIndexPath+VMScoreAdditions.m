//  Created by Alejandro Isaza on 2014-06-26.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "NSIndexPath+VMScoreAdditions.h"

@implementation NSIndexPath (VMScoreAdditions)

+ (NSIndexPath*)indexPathForItem:(NSUInteger)item ofType:(VMScoreElementType)type inPart:(NSUInteger)part {
    NSUInteger section = part * VMScoreElementTypeCount + type;
    return [NSIndexPath indexPathForItem:item inSection:section];
}

+ (NSUInteger)numberOfSectionsForPartCount:(NSUInteger)parts {
    return parts * VMScoreElementTypeCount;
}

+ (NSUInteger)partIndexForSection:(NSUInteger)section {
    return section / VMScoreElementTypeCount;
}

+ (VMScoreElementType)typeForSection:(NSUInteger)section {
    return section % VMScoreElementTypeCount;
}

- (NSUInteger)part {
    return [[self class] partIndexForSection:self.section];
}

- (VMScoreElementType)type {
    return [[self class] typeForSection:self.section];
}

@end
