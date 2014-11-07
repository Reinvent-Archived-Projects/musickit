//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKBeamLayer.h"
#import "VMKMeasureLayer.h"

#include "Chord.h"
#include "PartGeometry.h"

using namespace mxml::dom;


@interface VMKBeamLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKBeamLayerTests {
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
    XCTAssertTrue(size.height >= 3*mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

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
    
    Beam beam;
    beam.setNumber(2);
    beam.setType(Beam::TYPE_FORWARD_HOOK);
    note->addBeam(beam);
    
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
    
    Beam beam;
    beam.setNumber(2);
    beam.setType(Beam::TYPE_BACKWARD_HOOK);
    note->addBeam(beam);
    
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

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
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
    note->setAccidental(presentOptional(Accidental(Accidental::TYPE_SHARP)));
    
    chord.reset(new Chord);
    chord->addNote(std::move(note));
    self.measure->addNode(std::move(chord));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
