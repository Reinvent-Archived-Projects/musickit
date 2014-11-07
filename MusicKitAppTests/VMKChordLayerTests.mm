//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKChordLayer.h"
#import "VMKImageStore.h"

#include "PartGeometry.h"

using namespace mxml::dom;


@interface VMKChordLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKChordLayerTests {
    std::unique_ptr<Chord> _chord;
    Attributes _attributes;
}

- (void)setUp {
    [super setUp];
    
    Measure* measure = self.measure;
    
    std::unique_ptr<Attributes> attributes(new Attributes);
    _attributes.setStaves(presentOptional(1));
    
    Clef clef;
    clef.setNumber(1);
    clef.setSign(Clef::SIGN_G);
    clef.setLine(2);
    attributes->setClef(1, presentOptional(clef));
    
    _attributes = *attributes;
    measure->addNode(std::move(attributes));
    
    _chord.reset(new Chord);
}

- (void)tearDown {
    [super tearDown];
    _chord.reset();
}

- (std::unique_ptr<Note>)createNoteWithType:(Note::Type)type withPitch:(Pitch::Step)pitchStep inOctave:(int)octave {
    std::unique_ptr<Note> note(new Note);
    note->setType(type);
    
    Pitch pitch;
    pitch.setOctave(octave);
    pitch.setStep(pitchStep);
    note->setPitch(presentOptional(pitch));
    
    note->setMeasure(self.measure);
    
    return std::move(note);
}

- (void)testEighth {
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_B inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_G inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_F inOctave:3]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testEighthDown {
    auto note = [self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_B inOctave:4];
    note->setStem(STEM_DOWN);
    _chord->addNote(std::move(note));
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_G inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_F inOctave:3]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)test128th {
    _chord->addNote([self createNoteWithType:Note::TYPE_128TH withPitch:Pitch::STEP_B inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_128TH withPitch:Pitch::STEP_G inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_128TH withPitch:Pitch::STEP_F inOctave:3]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWhole {
    _chord->addNote([self createNoteWithType:Note::TYPE_WHOLE withPitch:Pitch::STEP_G inOctave:4]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height == mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testQuarter {
    _chord->addNote([self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDisplaceSideways {
    _chord->addNote([self createNoteWithType:Note::TYPE_HALF withPitch:Pitch::STEP_F inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_HALF withPitch:Pitch::STEP_G inOctave:4]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::PartGeometry::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDot {
    auto note = [self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4];
    note->setDot(presentOptional(EmptyPlacement()));
    _chord->addNote(std::move(note));

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccidental {
    auto note = [self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4];
    
    Accidental accidental;
    accidental.setType(Accidental::TYPE_SHARP);
    note->setAccidental(presentOptional(accidental));
    
    _chord->addNote(std::move(note));
    
    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccent {
    auto note = [self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4];
    
    Notations notations;
    Articulation articulation;
    articulation.setType(Articulation::ACCENT);
    notations.addArticulation(articulation);
    note->setNotations(presentOptional(notations));
    
    _chord->addNote(std::move(note));

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributes, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
