//  Created by Alejandro Isaza on 2014-04-01.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMClefView.h"

using namespace mxml;

@implementation VMClefView

+ (NSString*)imageNameForSign:(dom::Clef::Sign)sign {
    switch (sign) {
        case dom::Clef::SIGN_G: return @"treble-clef";
        case dom::Clef::SIGN_F: return @"bass-clef";
        default: return nil;
    }
}

- (id)initWithClefGeometry:(const ClefGeometry*)clefGeom {
    return [super initWithGeometry:clefGeom];
}

- (const ClefGeometry*)clefGeometry {
    return static_cast<const ClefGeometry*>(self.geometry);
}

- (void)setGeometry:(const Geometry *)geometry {
    [super setGeometry:geometry];
    
    if (geometry) {
        const dom::Clef& clef = self.clefGeometry->clef();
        self.imageName = [[self class] imageNameForSign:clef.sign()];
    } else {
        self.imageName = nil;
    }
}

@end
