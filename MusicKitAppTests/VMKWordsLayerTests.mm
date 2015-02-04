//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"
#import "VMKWordsLayer.h"
#include <mxml/geometry/WordsGeometry.h>


@interface VMKWordsLayerTests : VMKLayerTestCase

@end


@implementation VMKWordsLayerTests

- (void)testWords {
    std::unique_ptr<mxml::dom::Words> words(new mxml::dom::Words);
    words->setContents("Test words");

    mxml::dom::Direction direction;
    direction.setType(std::move(words));
    mxml::WordsGeometry geom(direction);

    VMKWordsLayer* layer = [[VMKWordsLayer alloc] initWithWordsGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testDyanmics {
    std::unique_ptr<mxml::dom::Dynamics> dynamics(new mxml::dom::Dynamics);
    dynamics->setString("pp");

    mxml::dom::Direction direction;
    direction.setType(std::move(dynamics));
    mxml::WordsGeometry geom(direction);

    VMKWordsLayer* layer = [[VMKWordsLayer alloc] initWithWordsGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
