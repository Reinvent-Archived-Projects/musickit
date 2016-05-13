// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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

@interface VMKOrnamentLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKOrnamentLayerTests {
    NSMutableArray* _chordViews;
    Attributes _attributes;
}

- (void)setUp {
    [super setUp];
    
    _attributes.setStaves(presentOptional(1));
    
    _chordViews = [[NSMutableArray alloc] init];
}

- (void)testTrillAbove {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);
    
    auto placement = Placement::Above;
    builder->addTrill(noteDown, placement);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testTrillBelow {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    auto placement = Placement::Below;
    builder->addTrill(noteUp, placement);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testMordentShort {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addMordent(noteUp, false);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testMordentLong {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 6);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addMordent(noteDown, true);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testInvertedMordentShort {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addInvertedMordent(noteUp, false);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testInvertedMordentLong {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 6);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addInvertedMordent(noteDown, true);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testTurnSlash {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 6);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addTurn(noteDown, true);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testTurnNoSlash {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addTurn(noteUp, false);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testInvertedTurnSlash {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 6);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addInvertedTurn(noteDown, true);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testInvertedTurnNoSlash {
    auto builder = self.builder;
    
    auto attributes = self.attributes;
    attributes->setStaves(presentOptional(1));
    
    auto noteDown = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 0, 1);
    builder->setPitch(noteDown, mxml::dom::Pitch::Step::E, 5);
    
    auto noteUp = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, 1, 1);
    builder->setPitch(noteUp, mxml::dom::Pitch::Step::F, 4);
    
    builder->addInvertedTurn(noteUp, false);
    
    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, false));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithGeometry:partGeometry];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
