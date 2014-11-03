//  Created by Alejandro Isaza on 2014-04-07.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMAccidentalView.h"
#import "VMChordView.h"
#import "VMDrawing.h"
#import "VMNoteHeadView.h"
#import "VMNoteStemView.h"

#import "FermataGeometry.h"
#include "MeasureGeometry.h"
#include "NoteGeometry.h"
#include <vector>

using namespace mxml;


static const CGFloat kStemWidth = 1;
static const CGFloat kStemOffset = 1;


@implementation VMChordView {
    NSMutableArray* _noteHeadViews;
    NSMutableArray* _otherViews;
}

- (id)initWithChordGeometry:(const ChordGeometry*)chordGeom {
    return [super initWithGeometry:chordGeom];
}

- (void)setup {
    [super setup];
    _noteHeadViews = [[NSMutableArray alloc] init];
    _otherViews = [[NSMutableArray alloc] init];
}

- (const ChordGeometry*)chordGeometry {
    return static_cast<const ChordGeometry*>(self.geometry);
}

- (void)setChordGeometry:(const mxml::ChordGeometry *)chordGeometry {
    self.geometry = chordGeometry;
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    
    if (self.chordGeometry && self.chordGeometry->stem()) {
        if (!_noteStemView) {
            _noteStemView = [[VMNoteStemView alloc] initWithGeometry:self.chordGeometry->stem()];
            _noteStemView.foregroundColor = self.foregroundColor;
            [self addSubview:_noteStemView];
        } else {
            _noteStemView.geometry = self.chordGeometry->stem();
        }
    } else if (_noteStemView) {
        _noteStemView.geometry = nullptr;
    }
    
    // Create new views
    [self clear];
    [self createSubviews];

    self.transform = CGAffineTransformIdentity;
    if (geometry) {
        auto note = self.chordGeometry->chord().firstNote();
        if (note && note->grace())
            self.transform = CGAffineTransformMakeScale(mxml::MeasureGeometry::kGraceNoteScale, mxml::MeasureGeometry::kGraceNoteScale);
    }

    [self setNeedsDisplay];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [super setForegroundColor:foregroundColor];
    for (VMNoteHeadView* view in _noteHeadViews)
        view.foregroundColor = foregroundColor;
    for (VMScoreElementView* view in _otherViews)
        view.foregroundColor = foregroundColor;
    _noteStemView.foregroundColor = foregroundColor;
    [self setNeedsDisplay];
}

- (void)clear {
    for (VMNoteHeadView* view in _noteHeadViews)
        [view removeFromSuperview];
    for (VMScoreElementView* view in _otherViews)
        [view removeFromSuperview];
    [_noteHeadViews removeAllObjects];
    [_otherViews removeAllObjects];
}

- (void)createSubviews {
    if (!self.geometry)
        return;
    
    for (auto& geom : self.chordGeometry->geometries()) {
        if (auto noteGeom = dynamic_cast<const NoteGeometry*>(geom.get())) {
            VMNoteHeadView* view = [[VMNoteHeadView alloc] initWithNoteGeometry:noteGeom];
            view.foregroundColor = self.foregroundColor;
            [_noteHeadViews addObject:view];
            [self addSubview:view];
        } else if (auto accidentalGeom = dynamic_cast<const AccidentalGeometry*>(geom.get())) {
            VMAccidentalView* accView = [[VMAccidentalView alloc] initWithAccidentalGeometry:accidentalGeom];
            accView.foregroundColor = self.foregroundColor;
            [_otherViews addObject:accView];
            [self addSubview:accView];
        } else if (auto dotGeom = dynamic_cast<const DotGeometry*>(geom.get())) {
            VMScoreElementImageView* dotView = [[VMScoreElementImageView alloc] initWithImageName:@"dot" geometry:dotGeom];
            dotView.foregroundColor = self.foregroundColor;
            [_otherViews addObject:dotView];
            [self addSubview:dotView];
        } else if (auto articulationGeom = dynamic_cast<const ArticulationGeometry*>(geom.get())) {
            [self createArticulation:articulationGeom];
        } else if (auto fermataGeom = dynamic_cast<const FermataGeometry*>(geom.get())) {
            [self createFermata:fermataGeom];
        }
    }
}

- (void)createArticulation:(const ArticulationGeometry*)geom {
    using mxml::dom::Articulation;

    NSString* imageName;
    switch (geom->articulation().type()) {
        case Articulation::ACCENT:
            imageName = @"accent";
            break;
        case Articulation::SPICCATO:
            imageName = @"spiccato";
            break;
            
        case Articulation::STACCATISSIMO:
            imageName = @"staccatissimo";
            break;
            
        case Articulation::STACCATO:
            imageName = @"dot";
            break;
            
        default:
            imageName = nil;
    }
    if (!imageName)
        return;
    
    VMScoreElementImageView* view = [[VMScoreElementImageView alloc] initWithImageName:imageName geometry:geom];
    if (geom->stem() == dom::STEM_UP)
        view.transform = CGAffineTransformMakeScale(1, -1);
    [_otherViews addObject:view];
    [self addSubview:view];
}

- (void)createFermata:(const FermataGeometry*)geom {
    using mxml::dom::Fermata;
    NSString* imageName = @"fermata";
    VMScoreElementImageView* view = [[VMScoreElementImageView alloc] initWithImageName:imageName geometry:geom];
    if (geom->fermata().type() == Fermata::TYPE_INVERTED)
        view.transform = CGAffineTransformMakeScale(1, -1);
    [_otherViews addObject:view];
    [self addSubview:view];
}

- (void)drawRect:(CGRect)rect {
    const ChordGeometry* geom = self.chordGeometry;
    if (!geom)
        return;
    const dom::Chord& chord = geom->chord();
    if (chord.type() >= dom::Note::TYPE_WHOLE || chord.stem() == dom::STEM_NONE)
        return;

    CGFloat x = geom->refNoteLocation().x;
    CGFloat miny = geom->refNoteLocation().y;
    CGFloat maxy = geom->refNoteLocation().y;
    for (VMNoteHeadView* view in _noteHeadViews) {
        CGPoint location = view.location;
        if (location.y < miny)
            miny = location.y;
        if (location.y > maxy)
            maxy = location.y;
    }

    CGPoint offset = self.bounds.origin;
    CGRect stemRect = CGRectZero;
    if (chord.stem() == dom::STEM_UP || chord.stem() == dom::STEM_DOUBLE) {
        stemRect.origin.y = offset.y;
        stemRect.origin.x = (x + NoteGeometry::kQuarterWidth/2 - kStemWidth);
        stemRect.size.height = maxy - offset.y - kStemOffset;
    } else if (chord.stem() == dom::STEM_DOWN) {
        stemRect.origin.y = miny + kStemOffset;
        stemRect.origin.x = (x - NoteGeometry::kQuarterWidth/2);
        stemRect.size.height = self.geometrySize.height - (miny - offset.y + kStemOffset);
    }
    stemRect.size.width = kStemWidth;

    [self.foregroundColor setFill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, VMRoundRect(stemRect));
}

@end
