// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKFileScoreTestCase.h"

#import "VMKSystemLayer.h"

#include <mxml/geometry/PageScoreGeometry.h>

@interface VMKSystemLayerTests : VMKFileScoreTestCase

@end

@implementation VMKSystemLayerTests

- (void)testSystem {
    auto score = [self loadScore:@"system"];
    auto scoreGeometry = std::unique_ptr<mxml::PageScoreGeometry>(new mxml::PageScoreGeometry(*score, 728));
    auto systemGeometry = scoreGeometry->systemGeometries().front();
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testOctaveShiftMultipleSystemsStart {
    auto score = [self loadScore:@"kiss_the_rain"];
    auto scoreGeometry = std::unique_ptr<mxml::PageScoreGeometry>(new mxml::PageScoreGeometry(*score, 728));
    auto systemGeometry = scoreGeometry->systemGeometries().at(0);
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testOctaveShiftMultipleSystemsStop {
    auto score = [self loadScore:@"kiss_the_rain"];
    auto scoreGeometry = std::unique_ptr<mxml::PageScoreGeometry>(new mxml::PageScoreGeometry(*score, 728));
    auto systemGeometry = scoreGeometry->systemGeometries().at(1);
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testCollidingWholeRests {
    auto score = [self loadScore:@"prelude_and_fugue_4"];
    auto scoreGeometry = std::unique_ptr<mxml::PageScoreGeometry>(new mxml::PageScoreGeometry(*score, 728));
    auto systemGeometry = scoreGeometry->systemGeometries().at(31);
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
