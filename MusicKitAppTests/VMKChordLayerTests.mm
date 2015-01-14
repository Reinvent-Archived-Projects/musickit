//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKChordLayer.h"
#import "VMKImageStore.h"

#include <mxml/ScoreBuilder.h>
#include <mxml/ScoreProperties.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/ScoreGeometry.h>
#include <mxml/Metrics.h>


using namespace mxml;
using namespace mxml::dom;


@interface VMKChordLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKChordLayerTests

- (void)testEighth {
    auto chord = self.builder->addChord(self.measure);

    auto note1 = self.builder->addNote(chord, Note::TYPE_EIGHTH);
    self.builder->setPitch(note1, Pitch::STEP_B, 4);

    auto note2 = self.builder->addNote(chord, Note::TYPE_EIGHTH);
    self.builder->setPitch(note2, Pitch::STEP_G, 4);

    auto note3 = self.builder->addNote(chord, Note::TYPE_EIGHTH);
    self.builder->setPitch(note3, Pitch::STEP_F, 3);

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testEighthDown {
    auto chord = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord, Note::TYPE_EIGHTH);
    self.builder->setPitch(note1, Pitch::STEP_B, 4);
    note1->setStem(STEM_DOWN);

    auto note2 = self.builder->addNote(chord, Note::TYPE_EIGHTH);
    self.builder->setPitch(note2, Pitch::STEP_G, 4);

    auto note3 = self.builder->addNote(chord, Note::TYPE_EIGHTH);
    self.builder->setPitch(note3, Pitch::STEP_F, 3);

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)test128th {
    auto chord = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord, Note::TYPE_128TH);
    self.builder->setPitch(note1, Pitch::STEP_B, 4);

    auto note2 = self.builder->addNote(chord, Note::TYPE_128TH);
    self.builder->setPitch(note2, Pitch::STEP_G, 4);

    auto note3 = self.builder->addNote(chord, Note::TYPE_128TH);
    self.builder->setPitch(note3, Pitch::STEP_F, 3);

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWhole {
    auto chord = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord, Note::TYPE_WHOLE);
    self.builder->setPitch(note2, Pitch::STEP_G, 4);

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height == mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testQuarter {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::TYPE_QUARTER);
    self.builder->setPitch(note, Pitch::STEP_G, 4);

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDisplaceSideways {
    auto chord = self.builder->addChord(self.measure);

    auto note1 = self.builder->addNote(chord, Note::TYPE_HALF);
    self.builder->setPitch(note1, Pitch::STEP_F, 4);

    auto note2 = self.builder->addNote(chord, Note::TYPE_HALF);
    self.builder->setPitch(note2, Pitch::STEP_G, 4);

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDot {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::TYPE_QUARTER);
    self.builder->setPitch(note, Pitch::STEP_G, 4);
    
    auto placement = std::unique_ptr<EmptyPlacement>(new EmptyPlacement{});
    note->setDot(std::move(placement));

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccidental {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::TYPE_QUARTER);
    self.builder->setPitch(note, Pitch::STEP_G, 4);
    
    auto accidential = std::unique_ptr<Accidental>(new Accidental{Accidental::TYPE_SHARP});
    note->setAccidental(std::move(accidential));

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccent {
    auto chord = self.builder->addChord(self.measure);
    auto note = self.builder->addNote(chord, Note::TYPE_QUARTER);
    self.builder->setPitch(note, Pitch::STEP_G, 4);
    
    auto articulation = std::unique_ptr<Articulation>(new Articulation{Articulation::ACCENT});
    
    auto notations = std::unique_ptr<Notations>(new Notations{});
    notations->addArticulation(std::move(articulation));
    note->setNotations(std::move(notations));

    auto score = self.builder->build();
    ScoreProperties properties(*score);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, false));
    auto partGeometry = static_cast<mxml::PartGeometry*>(scoreGeometry->geometries().front().get());

    mxml::ChordGeometry geom(*chord, properties, *partGeometry);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
