//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"

#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/ScoreGeometry.h>
#include <mxml/SpanFactory.h>

using namespace mxml::dom;

@implementation VMKAdHocScoreTestCase {
    std::unique_ptr<Score> _score;
    std::unique_ptr<mxml::ScoreGeometry> _scoreGeometry;
}

- (void)setUp {
    [super setUp];
    
    _score.reset(new Score());
    
    std::unique_ptr<Part> part(new Part());
    part->setParent(_score.get());
    
    std::unique_ptr<Measure> measure(new Measure);
    measure->setParent(part.get());
    
    part->addMeasure(std::move(measure));
    _score->addPart(std::move(part));
}

- (void)tearDown {
    _score.reset();
}

- (Score*)score {
    return _score.get();
}

- (Part*)part {
    return _score->parts().at(0).get();
}

- (Measure*)measure {
    return _score->parts()[0]->measures()[0].get();
}

- (mxml::ScoreGeometry*)scoreGeometry {
    _scoreGeometry.reset(new mxml::ScoreGeometry(*_score, false));
    return _scoreGeometry.get();
}

- (mxml::PartGeometry*)partGeometry {
    return static_cast<mxml::PartGeometry*>([self scoreGeometry]->geometries().front().get());
}

- (mxml::MeasureGeometry*)measureGeometry {
    return [self partGeometry]->measureGeometries().front();
}

- (std::unique_ptr<Note>)createNoteType:(Note::Type)type pitch:(Pitch::Step)pitchStep octave:(int)octave {
    std::unique_ptr<Note> note(new Note);
    note->setType(type);
    
    Pitch pitch;
    pitch.setOctave(octave);
    pitch.setStep(pitchStep);
    note->setPitch(presentOptional(pitch));
    
    note->setMeasure(self.measure);
    
    return std::move(note);
}

- (std::unique_ptr<Note>)createNoteType:(Note::Type)type pitch:(Pitch::Step)pitchStep octave:(int)octave beamType:(Beam::Type)beamType numberOfBeams:(int)beamCount {
    std::unique_ptr<Note> note(new Note);
    note->setType(type);
    
    Pitch pitch;
    pitch.setOctave(octave);
    pitch.setStep(pitchStep);
    note->setPitch(presentOptional(pitch));
    
    for (int bi = 1; bi <= beamCount; bi += 1) {
        Beam beam;
        beam.setNumber(1);
        beam.setType(beamType);
        note->addBeam(beam);
    }
    
    note->setMeasure(self.measure);
    
    return std::move(note);
}

@end
