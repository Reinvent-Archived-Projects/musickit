//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKTieLayer.h"
#include <mxml/dom/Chord.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/factories/TieGeometryFactory.h>

using namespace mxml;
using namespace mxml::dom;

static const CGFloat kTieAccuracy = 0.045;


@interface VMKTieLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKTieLayerTests {
    NSMutableArray* _chordViews;
    Attributes _attributes;
}

- (void)setUp {
    [super setUp];
    
    _attributes.setStaves(presentOptional(1));
    
    _chordViews = [[NSMutableArray alloc] init];
}

- (void)test18Tie {
    TieGeometry geom({0, 10}, {18, 10}, kPlacementAbove);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test50Tie {
    TieGeometry geom({0, 10}, {50, 10}, kPlacementAbove);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test50TieBelow {
    TieGeometry geom({0, 10}, {50, 10}, kPlacementBelow);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledDown {
    TieGeometry geom({0, 10}, {50, 30}, kPlacementAbove);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledDownBelow {
    TieGeometry geom({0, 10}, {50, 30}, kPlacementBelow);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledUp {
    TieGeometry geom({0, 30}, {50, 10}, kPlacementAbove);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledUpBelow {
    TieGeometry geom({0, 30}, {50, 10}, kPlacementBelow);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test100Tie {
    TieGeometry geom({0, 10}, {100, 10}, kPlacementAbove);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test1000Tie {
    TieGeometry geom({0, 10}, {1000, 10}, kPlacementAbove);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:0.001];
}

@end
