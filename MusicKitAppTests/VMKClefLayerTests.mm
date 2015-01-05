//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
