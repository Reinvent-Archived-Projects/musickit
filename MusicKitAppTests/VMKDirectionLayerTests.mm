//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"
#import "VMKDirectionLayer.h"
#include <mxml/geometry/DirectionGeometry.h>


@interface VMKDirectionLayerTests : VMKLayerTestCase

@end


@implementation VMKDirectionLayerTests

- (void)testWords {
    std::unique_ptr<mxml::dom::Words> words(new mxml::dom::Words);
    words->setContents("Test words");

    mxml::dom::Direction direction;
    direction.setType(std::move(words));
    mxml::DirectionGeometry geom(direction);

    VMKDirectionLayer* layer = [[VMKDirectionLayer alloc] initWithDirectionGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDyanmics {
    std::unique_ptr<mxml::dom::Dynamics> dynamics(new mxml::dom::Dynamics);
    dynamics->setString("pp");

    mxml::dom::Direction direction;
    direction.setType(std::move(dynamics));
    mxml::DirectionGeometry geom(direction);

    VMKDirectionLayer* layer = [[VMKDirectionLayer alloc] initWithDirectionGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
