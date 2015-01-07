//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKChordLayer.h"
#import "VMKImageStore.h"

#include "AttributesManager.h"
#include "PartGeometry.h"
#include "Metrics.h"


using namespace mxml;
using namespace mxml::dom;


@interface VMKChordLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKChordLayerTests {
    std::unique_ptr<Chord> _chord;
    Attributes* _attributes;
    AttributesManager _attributesManager;
}

- (void)setUp {
    [super setUp];
    
    Measure* measure = self.measure;
    
    std::unique_ptr<Attributes> attributes(new Attributes);
    attributes->setStaves(presentOptional(1));
    
    auto clef = std::unique_ptr<Clef>(new Clef{});
    clef->setNumber(1);
    clef->setSign(Clef::SIGN_G);
    clef->setLine(2);
    attributes->setClef(1, std::move(clef));
    
    _attributes = attributes.get();
    measure->addNode(std::move(attributes));
    
    _attributesManager.addAllAttributes(*measure);
    
    _chord.reset(new Chord);
}

- (void)tearDown {
    [super tearDown];
    _chord.reset();
}

- (std::unique_ptr<Note>)createNoteWithType:(Note::Type)type withPitch:(Pitch::Step)pitchStep inOctave:(int)octave {
    std::unique_ptr<Note> note(new Note);
    note->setType(type);
    
    auto pitch = std::unique_ptr<Pitch>(new Pitch{});
    pitch->setOctave(octave);
    pitch->setStep(pitchStep);
    note->setPitch(std::move(pitch));
    
    note->setMeasure(self.measure);
    
    return std::move(note);
}

- (void)testEighth {
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_B inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_G inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_F inOctave:3]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testEighthDown {
    auto note = [self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_B inOctave:4];
    note->setStem(STEM_DOWN);
    _chord->addNote(std::move(note));
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_G inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_EIGHTH withPitch:Pitch::STEP_F inOctave:3]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)test128th {
    _chord->addNote([self createNoteWithType:Note::TYPE_128TH withPitch:Pitch::STEP_B inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_128TH withPitch:Pitch::STEP_G inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_128TH withPitch:Pitch::STEP_F inOctave:3]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= 3*mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWhole {
    _chord->addNote([self createNoteWithType:Note::TYPE_WHOLE withPitch:Pitch::STEP_G inOctave:4]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height == mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testQuarter {
    _chord->addNote([self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDisplaceSideways {
    _chord->addNote([self createNoteWithType:Note::TYPE_HALF withPitch:Pitch::STEP_F inOctave:4]);
    _chord->addNote([self createNoteWithType:Note::TYPE_HALF withPitch:Pitch::STEP_G inOctave:4]);

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height >= mxml::Metrics::kStaffLineSpacing, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testDot {
    auto note = [self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4];
    
    auto placement = std::unique_ptr<EmptyPlacement>(new EmptyPlacement{});
    note->setDot(std::move(placement));
    _chord->addNote(std::move(note));

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccidental {
    auto note = [self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4];
    
    Accidental accidental;
    
    auto accidential = std::unique_ptr<Accidental>(new Accidental{Accidental::TYPE_SHARP});
    note->setAccidental(std::move(accidential));
    
    _chord->addNote(std::move(note));
    
    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccent {
    auto note = [self createNoteWithType:Note::TYPE_QUARTER withPitch:Pitch::STEP_G inOctave:4];
    
    auto articulation = std::unique_ptr<Articulation>(new Articulation{Articulation::ACCENT});
    
    auto notations = std::unique_ptr<Notations>(new Notations{});
    notations->addArticulation(std::move(articulation));
    note->setNotations(std::move(notations));
    
    _chord->addNote(std::move(note));

    mxml::PartGeometry* partGeom = [self partGeometry];
    mxml::ChordGeometry geom(*_chord, _attributesManager, *partGeom);
    VMKChordLayer* layer = [[VMKChordLayer alloc] initWithChordGeometry:&geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
