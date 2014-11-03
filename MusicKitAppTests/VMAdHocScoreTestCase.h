//  Created by Alejandro Isaza on 2014-05-09.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMViewTestCase.h"

#include "Note.h"
#include "MeasureGeometry.h"
#include "Score.h"
#include "SpanCollection.h"
#include <memory>

@interface VMAdHocScoreTestCase : VMViewTestCase

- (mxml::dom::Score*)score;
- (mxml::dom::Part*)part;
- (mxml::dom::Measure*)measure;

- (mxml::PartGeometry*)partGeometry;
- (mxml::MeasureGeometry*)measureGeometry;

- (std::unique_ptr<mxml::dom::Note>)createNoteType:(mxml::dom::Note::Type)type pitch:(mxml::dom::Pitch::Step)pitchStep octave:(int)octave;
- (std::unique_ptr<mxml::dom::Note>)createNoteType:(mxml::dom::Note::Type)type pitch:(mxml::dom::Pitch::Step)pitchStep octave:(int)octave beamType:(mxml::dom::Beam::Type)beamType numberOfBeams:(int)beamCount;

@end
