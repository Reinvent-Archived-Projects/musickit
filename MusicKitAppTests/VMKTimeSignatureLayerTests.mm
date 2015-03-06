//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKImageStore.h"
#import "VMKTimeSignatureLayer.h"


@interface VMKTimeSignatureLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKTimeSignatureLayerTests

- (void)testCommonTime {
    mxml::dom::Time time;
    time.setSymbol(mxml::dom::Time::Symbol::Common);
    
    mxml::TimeSignatureGeometry geom(time);
    VMKTimeSignatureLayer* layer = [[VMKTimeSignatureLayer alloc] initWithTimeSignatureGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testVerticalDigits {
    mxml::dom::Time time;
    time.setBeats(3);
    time.setBeatType(16);
    
    mxml::TimeSignatureGeometry geom(time);
    VMKTimeSignatureLayer* layer = [[VMKTimeSignatureLayer alloc] initWithTimeSignatureGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
