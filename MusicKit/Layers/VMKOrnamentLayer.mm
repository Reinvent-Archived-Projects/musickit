//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
        return @"inverted-mordent";
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
