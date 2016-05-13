// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"
#import "VMKBeamLayer.h"
#import "VMKMeasureLayer.h"

#include <mxml/dom/Chord.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
#include <mxml/ScrollMetrics.h>

using namespace mxml::dom;


@interface VMKBeamLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKBeamLayerTests {
    NSMutableArray* _chordViews;
}

- (void)setUp {
    [super setUp];
    _chordViews = [[NSMutableArray alloc] init];

    self.attributes->setDivisions(presentOptional(1));
    self.attributes->setClef(1, std::unique_ptr<Clef>{new Clef});
}

- (void)tearDown {
    [super tearDown];
    _chordViews = nil;
}

- (void)addBeamToNote:(Note*)note beamType:(Beam::Type)beamType numberOfBeams:(int)beamCount {
    for (int bi = 1; bi <= beamCount; bi += 1) {
        auto beam = std::unique_ptr<Beam>(new Beam{});
        beam->setNumber(1);
        beam->setType(beamType);
        note->addBeam(std::move(beam));
    }
}

- (void)testOneBeam {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::Eighth, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::A, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:1];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::Eighth, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::End numberOfBeams:1];

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testOneBeamThreeNotes {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::_64th, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::C, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:1];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::_64th, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::Continue numberOfBeams:1];

    auto chord3 = self.builder->addChord(self.measure);
    auto note3 = self.builder->addNote(chord3, Note::Type::_64th, 2, 1);
    note3->setVoice("1");
    self.builder->setPitch(note3, Pitch::Step::D, 4);
    [self addBeamToNote:note3 beamType:Beam::Type::End numberOfBeams:1];

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testForwardHook {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::Eighth, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::A, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:1];

    auto beam = std::unique_ptr<Beam>(new Beam{});
    beam->setNumber(2);
    beam->setType(Beam::Type::ForwardHook);
    note1->addBeam(std::move(beam));

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::Eighth, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::End numberOfBeams:1];

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testBackwardHook {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::Eighth, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::A, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:1];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::Eighth, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::End numberOfBeams:1];

    auto beam = std::unique_ptr<Beam>(new Beam{});
    beam->setNumber(2);
    beam->setType(Beam::Type::BackwardHook);
    note2->addBeam(std::move(beam));

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testTwoBeams {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::_16th, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::A, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:2];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::_16th, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::End numberOfBeams:2];

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testFourBeams {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::_64th, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::C, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:4];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::_64th, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::Continue numberOfBeams:4];

    auto chord3 = self.builder->addChord(self.measure);
    auto note3 = self.builder->addNote(chord3, Note::Type::_64th, 2, 1);
    note3->setVoice("1");
    self.builder->setPitch(note3, Pitch::Step::D, 4);
    [self addBeamToNote:note3 beamType:Beam::Type::End numberOfBeams:4];

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAccidentalInBeamedSet {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::Type::Eighth, 0, 1);
    note1->setVoice("1");
    self.builder->setPitch(note1, Pitch::Step::A, 4);
    [self addBeamToNote:note1 beamType:Beam::Type::Begin numberOfBeams:1];
    note1->setStem(Stem::Down);

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::Type::Eighth, 1, 1);
    note2->setVoice("1");
    self.builder->setPitch(note2, Pitch::Step::B, 4);
    [self addBeamToNote:note2 beamType:Beam::Type::End numberOfBeams:1];
    note2->setStem(Stem::Down);
    
    auto accidental = std::unique_ptr<Accidental>(new Accidental{Accidental::Type::Sharp});
    note2->accidental = std::move(accidental);

    auto score = self.builder->build();

    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
