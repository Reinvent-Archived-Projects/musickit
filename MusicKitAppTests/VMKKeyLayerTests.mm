//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKKeyLayer.h"

#include <mxml/dom/Clef.h>
#include <mxml/dom/Key.h>

// There is a placement inconsistency between iOS and MacOS so we need a larger tolerance
static const CGFloat kKeyAlphaTolerance = 0.018;


@interface VMKKeyLayerTests : VMKAdHocScoreTestCase
@end


@implementation VMKKeyLayerTests

- (void)testCMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(0);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];
    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
}

- (void)testGMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(1);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
}

- (void)testDFlatMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(-5);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
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

    [self testLayer:layer forSelector:_cmd alphaTolerance:kKeyAlphaTolerance];
}

@end
