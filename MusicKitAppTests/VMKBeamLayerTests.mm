//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKBeamLayer.h"
#import "VMKMeasureLayer.h"

#include <mxml/dom/Chord.h>
#include <mxml/geometry/ScoreGeometry.h>
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
    self.attributes->setClef(1, std::unique_ptr<Clef>{});
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
    auto note1 = self.builder->addNote(chord1, Note::TYPE_EIGHTH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_A, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:1];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_EIGHTH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kTypeEnd numberOfBeams:1];

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testOneBeamThreeNotes {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::TYPE_64TH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_C, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:1];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_64TH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kContinue numberOfBeams:1];

    auto chord3 = self.builder->addChord(self.measure);
    auto note3 = self.builder->addNote(chord3, Note::TYPE_64TH, 2, 1);
    self.builder->setPitch(note3, Pitch::STEP_D, 4);
    [self addBeamToNote:note3 beamType:Beam::kTypeEnd numberOfBeams:1];

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testForwardHook {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::TYPE_EIGHTH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_A, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:1];

    auto beam = std::unique_ptr<Beam>(new Beam{});
    beam->setNumber(2);
    beam->setType(Beam::kTypeForwardHook);
    note1->addBeam(std::move(beam));

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_EIGHTH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kTypeEnd numberOfBeams:1];

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testBackwardHook {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::TYPE_EIGHTH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_A, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:1];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_EIGHTH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kTypeEnd numberOfBeams:1];

    auto beam = std::unique_ptr<Beam>(new Beam{});
    beam->setNumber(2);
    beam->setType(Beam::kTypeBackwardHook);
    note2->addBeam(std::move(beam));

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testTwoBeams {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::TYPE_16TH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_A, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:2];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_16TH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kTypeEnd numberOfBeams:2];

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testFourBeams {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::TYPE_64TH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_C, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:4];

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_64TH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kContinue numberOfBeams:4];

    auto chord3 = self.builder->addChord(self.measure);
    auto note3 = self.builder->addNote(chord3, Note::TYPE_64TH, 2, 1);
    self.builder->setPitch(note3, Pitch::STEP_D, 4);
    [self addBeamToNote:note3 beamType:Beam::kTypeEnd numberOfBeams:4];

    auto score = self.builder->build();
    mxml::ScoreProperties properties(*score);
    mxml::ScrollMetrics metrics(*score, properties);

    auto scoreGeometry = std::unique_ptr<mxml::ScoreGeometry>(new mxml::ScoreGeometry(*score, properties, metrics, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    auto measureGeometry = partGeometry->measureGeometries().front();
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:measureGeometry];

    [self testLayer:layer forSelector:_cmd withAccuracy:0.01];
}

- (void)testAccidentalInBeamedSet {
    auto chord1 = self.builder->addChord(self.measure);
    auto note1 = self.builder->addNote(chord1, Note::TYPE_EIGHTH, 0, 1);
    self.builder->setPitch(note1, Pitch::STEP_A, 4);
    [self addBeamToNote:note1 beamType:Beam::kTypeBegin numberOfBeams:1];
    note1->setStem(kStemDown);

    auto chord2 = self.builder->addChord(self.measure);
    auto note2 = self.builder->addNote(chord2, Note::TYPE_EIGHTH, 1, 1);
    self.builder->setPitch(note2, Pitch::STEP_B, 4);
    [self addBeamToNote:note2 beamType:Beam::kTypeEnd numberOfBeams:1];
    note2->setStem(kStemDown);
    
    auto accidental = std::unique_ptr<Accidental>(new Accidental{Accidental::kTypeSharp});
    note2->setAccidental(std::move(accidental));

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
