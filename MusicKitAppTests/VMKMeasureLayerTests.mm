// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"
#import "VMKFileScoreTestCase.h"

#import "VMKMeasureLayer.h"

#include <mxml/dom/Print.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
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
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testWithClefs {
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(2));
    self.builder->setTrebleClef(attributes, 1);
    self.builder->setBassClef(attributes, 2);

    auto score = self.builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testWithTimeSignatures {
    auto attributes = self.attributes;
    attributes->setClef(1, std::unique_ptr<Clef>{new Clef});
    attributes->setClef(2, std::unique_ptr<Clef>{new Clef});

    auto time = self.builder->setTime(attributes);
    time->setBeats(3);
    time->setBeatType(4);

    auto score = self.builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testWithClefsAndTimeSignatures {
    auto attributes = self.attributes;

    auto time = self.builder->setTime(attributes);
    time->setBeats(3);
    time->setBeatType(4);

    auto score = self.builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testStemDirections {
    auto builder = self.builder;

    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));

    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);

    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testStemExtensions {
    auto builder = self.builder;

    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));

    auto note1 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note1, mxml::dom::Pitch::Step::A, 3);

    auto note2 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note2, mxml::dom::Pitch::Step::E, 3);

    auto note3 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note3, mxml::dom::Pitch::Step::D, 6);

    auto note4 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 3, 1);
    builder->setPitch(note4, mxml::dom::Pitch::Step::A, 6);

    auto note5 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 4, 1);
    builder->setPitch(note5, mxml::dom::Pitch::Step::A, 4);

    auto note6 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 5, 1);
    builder->setPitch(note6, mxml::dom::Pitch::Step::C, 5);

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end


@interface VMKMeasureLayerFileTests : VMKFileScoreTestCase

@end

@implementation VMKMeasureLayerFileTests

- (void)testRepeatAccidentals {
    auto score = [self loadScore:@"kiss_the_rain"];
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, true));
    auto measureGeometry = scoreGeometry->partGeometries().at(0)->measureGeometries().at(45);
    VMKMeasureLayer *layer = [[VMKMeasureLayer alloc] initWithGeometry:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end

