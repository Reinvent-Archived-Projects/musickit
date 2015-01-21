//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAccidentalLayer.h"
#import "VMKChordLayer.h"
#import "VMKGeometry.h"
#import "VMKNoteHeadLayer.h"
#import "VMKNoteStemLayer.h"

#include <mxml/geometry/FermataGeometry.h>
#include <mxml/geometry/MeasureGeometry.h>
#include <mxml/geometry/NoteGeometry.h>
#include <vector>


static const CGFloat kStemWidth = 1;
static const CGFloat kStemOffset = 1;

using namespace mxml;


@implementation VMKChordLayer {
    NSMutableArray* _noteHeadLayers;
    NSMutableArray* _otherLayers;
}

- (instancetype)initWithChordGeometry:(const ChordGeometry*)chordGeom {
    return [super initWithGeometry:chordGeom];
}

- (void)setup {
    [super setup];
    _noteHeadLayers = [[NSMutableArray alloc] init];
    _otherLayers = [[NSMutableArray alloc] init];
}

- (const ChordGeometry*)chordGeometry {
    return static_cast<const ChordGeometry*>(self.geometry);
}

- (void)setChordGeometry:(const mxml::ChordGeometry*)chordGeometry {
    self.geometry = chordGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];

    if (self.chordGeometry && self.chordGeometry->stem()) {
        if (!_noteStemLayer) {
            _noteStemLayer = [[VMKNoteStemLayer alloc] initWithGeometry:self.chordGeometry->stem()];
            _noteStemLayer.foregroundColor = self.foregroundColor;
            [self addSublayer:_noteStemLayer];
        } else {
            _noteStemLayer.geometry = self.chordGeometry->stem();
        }
        _noteStemLayer.hidden = NO;
    } else if (_noteStemLayer) {
        _noteStemLayer.geometry = nullptr;
        _noteStemLayer.hidden = YES;
    }

    // Create new layers
    [self clear];
    [self createSublayers];

    self.affineTransform = CGAffineTransformIdentity;
    if (geometry) {
        auto note = self.chordGeometry->chord().firstNote();
        if (note && note->grace())
            self.affineTransform = CGAffineTransformMakeScale(mxml::MeasureGeometry::kGraceNoteScale, mxml::MeasureGeometry::kGraceNoteScale);
    }

    [self setNeedsDisplay];
}

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    [super setForegroundColor:foregroundColor];
    for (VMKNoteHeadLayer* layer in _noteHeadLayers)
        layer.foregroundColor = foregroundColor;
    for (VMKScoreElementLayer* layer in _otherLayers)
        layer.foregroundColor = foregroundColor;
    _noteStemLayer.foregroundColor = foregroundColor;
    [self setNeedsDisplay];
}

- (void)clear {
    for (VMKNoteHeadLayer* layer in _noteHeadLayers)
        [layer removeFromSuperlayer];
    for (VMKScoreElementLayer* layer in _otherLayers)
        [layer removeFromSuperlayer];
    [_noteHeadLayers removeAllObjects];
    [_otherLayers removeAllObjects];
}

- (void)createSublayers {
    if (!self.geometry)
        return;

    for (auto& geom : self.chordGeometry->geometries()) {
        if (auto noteGeom = dynamic_cast<const NoteGeometry*>(geom.get())) {
            VMKNoteHeadLayer* layer = [[VMKNoteHeadLayer alloc] initWithNoteGeometry:noteGeom];
            layer.foregroundColor = self.foregroundColor;
            [_noteHeadLayers addObject:layer];
            [self addSublayer:layer];
        } else if (auto accidentalGeom = dynamic_cast<const AccidentalGeometry*>(geom.get())) {
            VMKAccidentalLayer* accLayer = [[VMKAccidentalLayer alloc] initWithAccidentalGeometry:accidentalGeom];
            accLayer.foregroundColor = self.foregroundColor;
            [_otherLayers addObject:accLayer];
            [self addSublayer:accLayer];
        } else if (auto dotGeom = dynamic_cast<const DotGeometry*>(geom.get())) {
            VMKScoreElementImageLayer* dotView = [[VMKScoreElementImageLayer alloc] initWithImageName:@"dot" geometry:dotGeom];
            dotView.foregroundColor = self.foregroundColor;
            [_otherLayers addObject:dotView];
            [self addSublayer:dotView];
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

    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:imageName geometry:geom];
    if (geom->stem() == dom::kStemUp)
        layer.affineTransform = CGAffineTransformMakeScale(1, -1);
    [_otherLayers addObject:layer];
    [self addSublayer:layer];
}

- (void)createFermata:(const FermataGeometry*)geom {
    using mxml::dom::Fermata;
    NSString* imageName = @"fermata";
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:imageName geometry:geom];
    if (geom->fermata().type() == Fermata::TYPE_INVERTED)
        layer.affineTransform = CGAffineTransformMakeScale(1, -1);
    [_otherLayers addObject:layer];
    [self addSublayer:layer];
}

- (void)drawInContext:(CGContextRef)ctx{
    const ChordGeometry* geom = self.chordGeometry;
    if (!geom)
        return;
    const dom::Chord& chord = geom->chord();
    if (chord.type() >= dom::Note::TYPE_WHOLE || chord.stem() == dom::kStemNone)
        return;

    CGFloat x = geom->refNoteLocation().x;
    CGFloat miny = geom->refNoteLocation().y;
    CGFloat maxy = geom->refNoteLocation().y;
    for (VMKNoteHeadLayer* layer in _noteHeadLayers) {
        CGPoint location = layer.position;
        if (location.y < miny)
            miny = location.y;
        if (location.y > maxy)
            maxy = location.y;
    }

    CGPoint offset = self.bounds.origin;
    CGRect stemRect = CGRectZero;
    if (chord.stem() == dom::kStemUp || chord.stem() == dom::kStemDouble) {
        stemRect.origin.y = offset.y;
        stemRect.origin.x = (x + NoteGeometry::kQuarterWidth/2 - kStemWidth);
        stemRect.size.height = maxy - offset.y - kStemOffset;
    } else if (chord.stem() == dom::kStemDown) {
        stemRect.origin.y = miny + kStemOffset;
        stemRect.origin.x = (x - NoteGeometry::kQuarterWidth/2);
        stemRect.size.height = self.preferredFrameSize.height - (miny - offset.y + kStemOffset);
    }
    stemRect.size.width = kStemWidth;

    CGContextSetFillColorWithColor(ctx, self.foregroundColor);

    CGContextFillRect(ctx, VMKRoundRect(stemRect));
}

@end
