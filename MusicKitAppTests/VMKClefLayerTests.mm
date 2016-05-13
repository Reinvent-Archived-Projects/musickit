// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"
#import "VMKClefLayer.h"

#include "Score.h"

using namespace mxml::dom;

@interface VMKClefLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKClefLayerTests

- (void)testTreble {
    auto clef = Clef::trebleClef();
    mxml::ClefGeometry geom(*clef);
    VMKClefLayer* layer = [[VMKClefLayer alloc] initWithClefGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
