// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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

- (void)testDontCropSlanted {
    std::unique_ptr<mxml::dom::Dynamics> dynamics(new mxml::dom::Dynamics);
    dynamics->setString("f");

    mxml::dom::Direction direction;
    direction.setType(std::move(dynamics));
    mxml::WordsGeometry geom(direction);

    VMKWordsLayer* layer = [[VMKWordsLayer alloc] initWithWordsGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
