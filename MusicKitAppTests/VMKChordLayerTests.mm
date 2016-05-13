// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"
#import "VMKChordLayer.h"
#import "VMKImageStore.h"

#include <mxml/ScoreBuilder.h>
#include <mxml/ScoreProperties.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
#include <mxml/geometry/factories/ChordGeometryFactory.h>
#include <mxml/Metrics.h>


using namespace mxml;
using namespace mxml::dom;


@interface VMKChordLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKChordLayerTests

- (void)testEighth {
    auto chord = self.builder->addChord(self.measure);

    auto note1 = self.builder->addNote(chord, Note::Type::Eighth);
    self.builder->setPitch(note1, Pitch::Step::B, 4);

    auto note2 = self.builder->addNote(chord, Note::Type::Eighth);
    self.builder->setPitch(note2, Pitch::Step::G, 4);

    auto note3 = self.builder->addNote(chord, Note::Type::Eighth);
    self.builder->setPitch(note3, Pitch::Step::F, 3);

    auto score = self.builder->build();
    ScoreProperties properties(*score, ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testEighthDown {
    auto chord = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord, Note::Type::Eighth);
    self.builder->setPitch(note1, Pitch::Step::B, 4);
    note1->setStem(Stem::Down);

    auto note2 = self.builder->addNote(chord, Note::Type::Eighth);
    self.builder->setPitch(note2, Pitch::Step::G, 4);

    auto note3 = self.builder->addNote(chord, Note::Type::Eighth);
    self.builder->setPitch(note3, Pitch::Step::F, 3);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)test128th {
    auto chord = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord, Note::Type::_128th);
    self.builder->setPitch(note1, Pitch::Step::B, 4);

    auto note2 = self.builder->addNote(chord, Note::Type::_128th);
    self.builder->setPitch(note2, Pitch::Step::G, 4);

    auto note3 = self.builder->addNote(chord, Note::Type::_128th);
    self.builder->setPitch(note3, Pitch::Step::F, 3);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testWhole {
    auto chord = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord, Note::Type::Whole);
    self.builder->setPitch(note2, Pitch::Step::G, 4);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height == mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testQuarter {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::Type::Quarter);
    self.builder->setPitch(note, Pitch::Step::G, 4);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testDisplaceSideways {
    auto chord = self.builder->addChord(self.measure);

    auto note1 = self.builder->addNote(chord, Note::Type::Half);
    self.builder->setPitch(note1, Pitch::Step::F, 4);

    auto note2 = self.builder->addNote(chord, Note::Type::Half);
    self.builder->setPitch(note2, Pitch::Step::G, 4);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testDot {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::Type::Quarter);
    self.builder->setPitch(note, Pitch::Step::G, 4);
    
    auto placement = std::unique_ptr<EmptyPlacement>(new EmptyPlacement{});
    note->dot = std::move(placement);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAccidental {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::Type::Quarter);
    self.builder->setPitch(note, Pitch::Step::G, 4);
    
    auto accidential = std::unique_ptr<Accidental>(new Accidental{Accidental::Type::Sharp});
    note->accidental = std::move(accidential);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAccent {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::Type::Quarter);
    self.builder->setPitch(note, Pitch::Step::G, 4);
    
    auto articulation = std::unique_ptr<Articulation>(new Articulation{Articulation::Type::Accent});
    
    auto notations = std::unique_ptr<Notations>(new Notations{});
    notations->articulations.push_back(std::move(articulation));
    note->notations = std::move(notations);

    auto score = self.builder->build();
    ScoreProperties properties(*score, mxml::ScoreProperties::LayoutType::Scroll);
    ScrollMetrics metrics(*score, properties, 0);

    mxml::ChordGeometryFactory factory(properties, metrics);
    auto geom = factory.build(*chord);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:geom.get()];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
