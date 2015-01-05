//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKBeamLayer.h"
#import "VMKMeasureLayer.h"

#include "Chord.h"
#include "PartGeometry.h"
#include "Metrics.h"

using namespace mxml::dom;


@interface VMKBeamLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKBeamLayerTests {
    NSMutableArray* _chordViews;
    Attributes* _attributes;
}

- (void)setUp {
    [super setUp];
    
    std::unique_ptr<Attributes> attributes(new Attributes{});
    attributes->setStaves(presentOptional(1));
    
    _attributes = attributes.get();
    
    Measure* measure = self.measure;
    measure->addNode(std::move(attributes));
    
    _chordViews = [[NSMutableArray alloc] init];
}

- (void)tearDown {
    [super tearDown];
    _chordViews = nil;
}

- (void)testOneBeam {
    std::unique_ptr<Chord> chord(new Chord);
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_A octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:1];
    note->setStart(0);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    chord.reset(new Chord);
    note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_END numberOfBeams:1];
    note->setStart(1);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testOneBeamThreeNotes {
    std::unique_ptr<Chord> chord(new Chord);
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_64TH pitch:Pitch::STEP_C octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:1];
    note->setStart(0);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    chord.reset(new Chord);
    note = [self createNoteType:Note::TYPE_64TH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_CONTINUE numberOfBeams:1];
    note->setStart(1);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    chord.reset(new Chord);
    note = [self createNoteType:Note::TYPE_64TH pitch:Pitch::STEP_D octave:4 beamType:Beam::TYPE_END numberOfBeams:1];
    note->setStart(2);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testForwardHook {
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_A octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:1];
    note->setStart(0);
    
    auto beam = std::unique_ptr<Beam>(new Beam{});
    beam->setNumber(2);
    beam->setType(Beam::TYPE_FORWARD_HOOK);
    note->addBeam(std::move(beam));
    
    std::unique_ptr<Chord> chord(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_END numberOfBeams:1];
    note->setStart(1);
    chord.reset(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testBackwardHook {
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_A octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:1];
    note->setStart(0);
    
    std::unique_ptr<Chord> chord(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_END numberOfBeams:1];
    note->setStart(1);
    
    auto beam = std::unique_ptr<Beam>(new Beam{});
    beam->setNumber(2);
    beam->setType(Beam::TYPE_BACKWARD_HOOK);
    note->addBeam(std::move(beam));
    
    chord.reset(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testTwoBeams {
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_16TH pitch:Pitch::STEP_A octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:2];
    note->setStart(0);
    
    std::unique_ptr<Chord> chord(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    note = [self createNoteType:Note::TYPE_16TH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_END numberOfBeams:2];
    note->setStart(1);
    
    chord.reset(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testFourBeams {
    std::unique_ptr<Chord> chord(new Chord);
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_64TH pitch:Pitch::STEP_C octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:4];
    note->setStart(0);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    chord.reset(new Chord);
    note = [self createNoteType:Note::TYPE_64TH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_CONTINUE numberOfBeams:4];
    note->setStart(1);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    chord.reset(new Chord);
    note = [self createNoteType:Note::TYPE_64TH pitch:Pitch::STEP_D octave:4 beamType:Beam::TYPE_END numberOfBeams:4];
    note->setStart(2);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:0.01];
}

- (void)testAccidentalInBeamedSet {
    std::unique_ptr<Note> note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_A octave:4 beamType:Beam::TYPE_BEGIN numberOfBeams:1];
    note->setStem(STEM_DOWN);
    
    std::unique_ptr<Chord> chord(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));
    
    note = [self createNoteType:Note::TYPE_EIGHTH pitch:Pitch::STEP_B octave:4 beamType:Beam::TYPE_END numberOfBeams:1];
    note->setStart(1);
    note->setStem(STEM_DOWN);
    
    auto accidental = std::unique_ptr<Accidental>(new Accidental{Accidental::TYPE_SHARP});
    note->setAccidental(std::move(accidental));
    
    chord.reset(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
