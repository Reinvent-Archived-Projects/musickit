//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"

#include "Note.h"
#include "MeasureGeometry.h"
#include "Score.h"
#include "SpanCollection.h"
#include <memory>

@interface VMKAdHocScoreTestCase : VMKLayerTestCase

- (mxml::dom::Score*)score;
- (mxml::dom::Part*)part;
- (mxml::dom::Measure*)measure;

- (mxml::PartGeometry*)partGeometry;
- (mxml::MeasureGeometry*)measureGeometry;

- (std::unique_ptr<mxml::dom::Note>)createNoteType:(mxml::dom::Note::Type)type pitch:(mxml::dom::Pitch::Step)pitchStep octave:(int)octave;
- (std::unique_ptr<mxml::dom::Note>)createNoteType:(mxml::dom::Note::Type)type pitch:(mxml::dom::Pitch::Step)pitchStep octave:(int)octave beamType:(mxml::dom::Beam::Type)beamType numberOfBeams:(int)beamCount;

@end
