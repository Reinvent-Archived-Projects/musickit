// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "NSIndexPath+VMKScoreAdditions.h"

@implementation NSIndexPath (VMKScoreAdditions)

+ (NSIndexPath*)indexPathForItem:(NSUInteger)item ofType:(VMKScoreElementType)type inPart:(NSUInteger)part {
    NSUInteger section = part * VMKScoreElementTypeCount + type;
    return [NSIndexPath indexPathForItem:item inSection:section];
}

+ (NSUInteger)numberOfSectionsForPartCount:(NSUInteger)parts {
    return parts * VMKScoreElementTypeCount;
}

+ (NSUInteger)partIndexForSection:(NSUInteger)section {
    return section / VMKScoreElementTypeCount;
}

+ (VMKScoreElementType)typeForSection:(NSUInteger)section {
    return section % VMKScoreElementTypeCount;
}

- (NSUInteger)part {
    return [[self class] partIndexForSection:self.section];
}

- (VMKScoreElementType)type {
    return [[self class] typeForSection:self.section];
}

@end
