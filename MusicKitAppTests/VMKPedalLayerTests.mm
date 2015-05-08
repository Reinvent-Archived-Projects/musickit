//  Created by Aidan Gomez on 2015-05-05.
//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKPartLayer.h"
#import "VMKBeamLayer.h"
#import "VMKOrnamentLayer.h"
#import "VMKMeasureLayer.h"

#include <mxml/dom/Chord.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/OrnamentsGeometry.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/factories/OrnamentGeometryFactory.h>

using namespace mxml;
using namespace mxml::dom;

@interface VMKPedalLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKPedalLayerTests {
    NSMutableArray* _chordViews;
    Attributes _attributes;
}

- (void)setUp {
    [super setUp];
    
    _attributes.setStaves(presentOptional(1));
    
    _chordViews = [[NSMutableArray alloc] init];
}

- (void)testPedalSignStartStop {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto note1 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note1, mxml::dom::Pitch::Step::E, 5);
    
    auto type = StartStopContinue::kStart;
    builder->addPedal(self.measure, type, false, true, 0);
    
    auto note2 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note2, mxml::dom::Pitch::Step::F, 4);
    
    auto measure2 = builder->addMeasure(self.part);
    auto note3 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note3, mxml::dom::Pitch::Step::F, 4);
    auto note4 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note4, mxml::dom::Pitch::Step::F, 4);
    
    auto type2 = StartStopContinue::kStop;
    builder->addPedal(measure2, type2, false, true, 1);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testPedalLineStartStop {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto note1 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note1, mxml::dom::Pitch::Step::E, 5);
    auto note2 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note2, mxml::dom::Pitch::Step::F, 4);
    auto note3 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note3, mxml::dom::Pitch::Step::F, 5);
    
    builder->addPedal(self.measure, StartStopContinue::kStart, true, false, 0);
    
    auto measure2 = builder->addMeasure(self.part);
    auto note4 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note4, mxml::dom::Pitch::Step::F, 4);
    auto note5 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note5, mxml::dom::Pitch::Step::A, 5);
    auto note6 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note6, mxml::dom::Pitch::Step::G, 4);

    builder->addPedal(measure2, StartStopContinue::kStop, true, false, 1);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testPedalLineContinueStop {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto note1 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note1, mxml::dom::Pitch::Step::E, 5);
    auto note2 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note2, mxml::dom::Pitch::Step::F, 4);
    auto note3 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note3, mxml::dom::Pitch::Step::F, 5);
    
    builder->addPedal(self.measure, StartStopContinue::kContinue, true, false, 0);
    
    auto measure2 = builder->addMeasure(self.part);
    auto note4 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note4, mxml::dom::Pitch::Step::F, 4);
    auto note5 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note5, mxml::dom::Pitch::Step::A, 5);
    auto note6 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note6, mxml::dom::Pitch::Step::G, 4);
    
    builder->addPedal(measure2, StartStopContinue::kStop, true, false, 1);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testPedalSignContinueStop {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto note1 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note1, mxml::dom::Pitch::Step::E, 5);
    auto note2 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note2, mxml::dom::Pitch::Step::F, 4);
    auto note3 = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note3, mxml::dom::Pitch::Step::F, 5);
    
    builder->addPedal(self.measure, StartStopContinue::kContinue, false, true, 0);
    
    auto measure2 = builder->addMeasure(self.part);
    auto note4 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(note4, mxml::dom::Pitch::Step::F, 4);
    auto note5 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(note5, mxml::dom::Pitch::Step::A, 5);
    auto note6 = builder->addNote(measure2, mxml::dom::Note::Type::Quarter, 2, 1);
    builder->setPitch(note6, mxml::dom::Pitch::Step::G, 4);
    
    builder->addPedal(measure2, StartStopContinue::kStop, false, true, 1);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end