// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKLayerTestCase.h"
#import "VMKScoreElementImageLayer.h"

#import <mxml/geometry/CodaGeometry.h>
#import <mxml/geometry/SegnoGeometry.h>

@interface VMKImageLayerTests : VMKLayerTestCase

@end

@implementation VMKImageLayerTests

- (void)testCoda {
    mxml::dom::Segno coda;
    mxml::SegnoGeometry geom(coda);
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"coda" geometry:&geom];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testSegno {
    mxml::dom::Segno segno;
    mxml::SegnoGeometry geom(segno);
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"segno" geometry:&geom];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
