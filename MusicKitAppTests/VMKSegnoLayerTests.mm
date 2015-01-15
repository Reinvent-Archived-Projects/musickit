//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"
#import "VMKScoreElementImageLayer.h"

#import <mxml/geometry/SegnoGeometry.h>

@interface VMKSegnoLayerTests : VMKLayerTestCase

@end

@implementation VMKSegnoLayerTests

- (void)testSegno {
    mxml::dom::Segno segno;
    mxml::SegnoGeometry geom(segno);
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"segno" geometry:&geom];
    
    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
