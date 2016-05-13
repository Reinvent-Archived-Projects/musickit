// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKOrnamentLayer.h"

@implementation VMKOrnamentLayer

+ (NSString*)imageNameForOrnaments:(const mxml::dom::Ornaments&)ornaments {
    if (ornaments.trillMark().get()) {
        return @"trill";
    } else if (ornaments.turn().get()) {
        return @"turn";
    } else if (ornaments.invertedTurn().get()) {
        return @"inverted-turn";
    } else if (ornaments.mordent().get()) {
        return @"mordent";
    } else if (ornaments.invertedMordent().get()) {
        if (ornaments.invertedMordent().get()->isLong()) {
            return @"long-mordent";
        } else {
            return @"inverted-mordent";
        }
    }
    return nil;
}

- (instancetype)initWithOrnamentsGeometry:(const mxml::OrnamentsGeometry*)ornamentsGeometry {
    return [super initWithGeometry:ornamentsGeometry];
}

- (const mxml::OrnamentsGeometry*)ornamentsGeometry {
    return static_cast<const mxml::OrnamentsGeometry*>(self.geometry);
}

- (void)setOrnamentsGeometry:(const mxml::OrnamentsGeometry *)ornamentsGeometry {
    self.geometry = ornamentsGeometry;
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    auto ornamentsGeometry = static_cast<const mxml::OrnamentsGeometry*>(geometry);
    if (ornamentsGeometry)
        self.imageName = [self.class imageNameForOrnaments:ornamentsGeometry->ornaments()];
    else
        self.imageName = nil;

    [super setGeometry:geometry];
}

- (CGSize)preferredFrameSize {
    return self.image.size;
}

@end
