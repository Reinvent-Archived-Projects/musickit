//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKMeasureLayer.h"

#include <mxml/dom/Print.h>
#include <mxml/geometry/ScoreGeometry.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/SpanFactory.h>

using namespace mxml::dom;

@interface VMKMeasureLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKMeasureLayerTests

- (void)setUp {
    [super setUp];
    
    auto measure = self.measure;
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(2));
    self.builder->setTrebleClef(attributes, 1);
    self.builder->setBassClef(attributes, 2);
    
    std::unique_ptr<Print> print(new Print);
    print->staffDistances[2] = 65;
    
    measure->addNode(std::move(print));
}

- (void)testEmpty {
    self.attributes->setClef(1, std::unique_ptr<Clef>{});
    self.attributes->setClef(2, std::unique_ptr<Clef>{});

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWithClefs {
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(2));
    self.builder->setTrebleClef(attributes, 1);
    self.builder->setBassClef(attributes, 2);

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWithTimeSignatures {
    auto attributes = self.attributes;
    attributes->setClef(1, std::unique_ptr<Clef>{});
    attributes->setClef(2, std::unique_ptr<Clef>{});

    auto time = self.builder->setTime(attributes);
    time->setBeats(3);
    time->setBeatType(4);

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWithClefsAndTimeSignatures {
    auto attributes = self.attributes;

    auto time = self.builder->setTime(attributes);
    time->setBeats(3);
    time->setBeatType(4);

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
