//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKTieLayer.h"
#include <mxml/dom/Chord.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/TieGeometryFactory.h>

using namespace mxml;
using namespace mxml::dom;

static const CGFloat kTieAccuracy = 0.03;


@interface VMKTieLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKTieLayerTests {
    NSMutableArray* _chordViews;
    Attributes _attributes;
}

- (void)setUp {
    [super setUp];
    
    Measure* measure = self.measure;
    
    _attributes.setStaves(presentOptional(1));
    
    Clef clef;
    clef.setNumber(1);
    clef.setSign(Clef::SIGN_G);
    clef.setLine(2);
    _attributes.setClef(1, absentOptional(clef));
    measure->addNode(std::unique_ptr<Attributes>(new Attributes(_attributes)));
    
    _attributes.setClef(1, presentOptional(clef));
    measure->setBaseAttributes(_attributes);
    
    _chordViews = [[NSMutableArray alloc] init];
}

- (void)test18Tie {
    TieGeometry geom({0, 10}, {18, 10}, PLACEMENT_ABOVE);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test50Tie {
    TieGeometry geom({0, 10}, {50, 10}, PLACEMENT_ABOVE);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test50TieBelow {
    TieGeometry geom({0, 10}, {50, 10}, PLACEMENT_BELOW);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledDown {
    TieGeometry geom({0, 10}, {50, 30}, PLACEMENT_ABOVE);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledDownBelow {
    TieGeometry geom({0, 10}, {50, 30}, PLACEMENT_BELOW);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledUp {
    TieGeometry geom({0, 30}, {50, 10}, PLACEMENT_ABOVE);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)testAngledUpBelow {
    TieGeometry geom({0, 30}, {50, 10}, PLACEMENT_BELOW);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test100Tie {
    TieGeometry geom({0, 10}, {100, 10}, PLACEMENT_ABOVE);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:kTieAccuracy];
}

- (void)test1000Tie {
    TieGeometry geom({0, 10}, {1000, 10}, PLACEMENT_ABOVE);
    VMKTieLayer* view = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self testLayer:view forSelector:_cmd withAccuracy:0.001];
}

@end
