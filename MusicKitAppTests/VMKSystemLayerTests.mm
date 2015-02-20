//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"
#import "VMKSystemLayer.h"

#include <mxml/geometry/PageScoreGeometry.h>
#include <mxml/parsing/ScoreHandler.h>

#include "lxml.h"
#include <fstream>

@interface VMKSystemLayerTests : VMKLayerTestCase

@end

@implementation VMKSystemLayerTests {
    std::unique_ptr<mxml::dom::Score> _score;
    std::unique_ptr<mxml::PageScoreGeometry> _geometry;
}

- (void)load:(NSString*)path {
    mxml::ScoreHandler handler;
    std::ifstream is([path UTF8String]);
    lxml::parse(is, [path UTF8String], handler);
    _score = handler.result();

    if (!_score->parts().empty() && !_score->parts().front()->measures().empty()) {
        _geometry.reset(new mxml::PageScoreGeometry(*_score, 728));
    } else {
        _geometry.reset();
    }
}

- (void)testSystem {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"system" ofType:@"xml"];
    [self load:path];

    auto systemGeometry = _geometry->systemGeometries().front();
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testOctaveShiftMultipleSystemsStart {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"kiss_the_rain" ofType:@"xml"];
    [self load:path];

    auto systemGeometry = _geometry->systemGeometries()[0];
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        #if TARGET_OS_IPHONE
            XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
        #else
            XCTAssertLessThanOrEqual(errors.alphaError, 0.0002);
        #endif
    }];
}

- (void)testOctaveShiftMultipleSystemsStop {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"kiss_the_rain" ofType:@"xml"];
    [self load:path];

    auto systemGeometry = _geometry->systemGeometries()[1];
    VMKSystemLayer *layer = [[VMKSystemLayer alloc] initWithGeometry:systemGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        #if TARGET_OS_IPHONE
            XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
        #else
            XCTAssertLessThanOrEqual(errors.alphaError, 0.0002);
        #endif
    }];
}

@end
