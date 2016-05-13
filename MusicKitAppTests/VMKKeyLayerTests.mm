// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"
#import "VMKKeyLayer.h"

#include <mxml/dom/Clef.h>
#include <mxml/dom/Key.h>


@interface VMKKeyLayerTests : VMKAdHocScoreTestCase
@end


@implementation VMKKeyLayerTests

- (void)testGMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(1);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testDMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(2);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(3);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testEMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(4);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testBMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(5);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testFSharpMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(6);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testCSharpMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(7);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testFMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-1);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testBFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-2);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testEFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-3);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-4);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];}

- (void)testDFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-5);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testGFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-6);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testCFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-7);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
