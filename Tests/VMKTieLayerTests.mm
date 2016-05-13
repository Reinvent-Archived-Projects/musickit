// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"
#import "VMKPartLayer.h"
#import "VMKTieLayer.h"

#include <mxml/dom/Chord.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
#include <mxml/geometry/factories/TieGeometryFactory.h>

using namespace mxml;
using namespace mxml::dom;

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
    TieGeometry geom({0, 10}, {18, 10}, Placement::Above);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)test50Tie {
    TieGeometry geom({0, 10}, {50, 10}, Placement::Above);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)test50TieBelow {
    TieGeometry geom({0, 10}, {50, 10}, Placement::Below);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAngledDown {
    TieGeometry geom({0, 10}, {50, 30}, Placement::Above);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAngledDownBelow {
    TieGeometry geom({0, 10}, {50, 30}, Placement::Below);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAngledUp {
    TieGeometry geom({0, 30}, {50, 10}, Placement::Above);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAngledUpBelow {
    TieGeometry geom({0, 30}, {50, 10}, Placement::Below);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)test100Tie {
    TieGeometry geom({0, 10}, {100, 10}, Placement::Above);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)test1000Tie {
    TieGeometry geom({0, 10}, {1000, 10}, Placement::Above);
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:&geom];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testSlurPlacementDown {
    auto builder = self.builder;
    auto time = dom::time_t{};

    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 4);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStart);

        auto articulation = std::unique_ptr<dom::Articulation>(new Articulation{});
        articulation->setType(dom::Articulation::Type::Accent);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        notations->articulations.push_back(std::move(articulation));
        note->notations = std::move(notations);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::A, 4);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::G, 4);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::F, 4);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStop);

        auto articulation = std::unique_ptr<dom::Articulation>(new Articulation{});
        articulation->setType(dom::Articulation::Type::Staccato);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        notations->articulations.push_back(std::move(articulation));
        note->notations = std::move(notations);
    }

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithPartGeometry:partGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testSlurPlacementUp {
    auto builder = self.builder;
    auto time = dom::time_t{};

    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::B, 4);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStart);

        auto articulation = std::unique_ptr<dom::Articulation>(new Articulation{});
        articulation->setType(dom::Articulation::Type::Accent);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        notations->articulations.push_back(std::move(articulation));
        note->notations = std::move(notations);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 5);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::D, 5);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::C, 5);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStop);

        auto articulation = std::unique_ptr<dom::Articulation>(new Articulation{});
        articulation->setType(dom::Articulation::Type::Staccato);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        notations->articulations.push_back(std::move(articulation));
        note->notations = std::move(notations);
    }

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithPartGeometry:partGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testSlurPlacementUpDown {
    auto builder = self.builder;
    auto time = dom::time_t{};

    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 4);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStart);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        note->notations = std::move(notations);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::B, 4);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 5);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStop);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        note->notations = std::move(notations);
    }

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, true));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithPartGeometry:partGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testSlurPlacementDownUp {
    auto builder = self.builder;
    auto time = dom::time_t{};

    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 5);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStart);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        note->notations = std::move(notations);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::B, 4);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 4);

        auto slur = std::unique_ptr<dom::Slur>(new Slur{});
        slur->setType(dom::kStop);

        auto notations = std::unique_ptr<dom::Notations>(new Notations{});
        notations->slurs.push_back(std::move(slur));
        note->notations = std::move(notations);
    }

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, true));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithPartGeometry:partGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
