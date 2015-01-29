//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKKeyLayer.h"

#include <mxml/dom/Clef.h>
#include <mxml/dom/Key.h>

static const CGFloat kKeyRenderAccuracy = 0.002;


@interface VMKKeyLayerTests : VMKAdHocScoreTestCase
@end


@implementation VMKKeyLayerTests

- (void)testCMajor {
    auto clef = mxml::dom::Clef::trebleClef();
    auto key = mxml::dom::Key{};
    key.setFifths(0);

    mxml::KeyGeometry geometry(key, *clef);
    VMKKeyLayer* layer = [[VMKKeyLayer alloc] initWithKeyGeometry:&geometry];
    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
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

    [self testLayer:layer forSelector:_cmd withAccuracy:kKeyRenderAccuracy];
}

@end
