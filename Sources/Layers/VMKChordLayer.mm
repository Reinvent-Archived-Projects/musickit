// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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
            _noteStemLayer.activeForegroundColor = self.activeForegroundColor;
            _noteStemLayer.inactiveForegroundColor = self.inactiveForegroundColor;
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

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    [super setActiveForegroundColor:foregroundColor];
//    for (VMKNoteHeadLayer* layer in _noteHeadLayers)
//        layer.activeForegroundColor = foregroundColor;
    for (VMKScoreElementLayer* layer in _otherLayers)
        layer.activeForegroundColor = foregroundColor;
    _noteStemLayer.activeForegroundColor = foregroundColor;
}

- (void)setNoteHeadColor:(VMKColor*)noteHeadColor {
    for (int i = 0; i < _noteHeadLayers.count; i++) {
        ((VMKNoteHeadLayer *)_noteHeadLayers[i]).activeForegroundColor = noteHeadColor;
    }
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    [super setInactiveForegroundColor:foregroundColor];
    for (VMKNoteHeadLayer* layer in _noteHeadLayers)
        layer.inactiveForegroundColor = foregroundColor;
    for (VMKScoreElementLayer* layer in _otherLayers)
        layer.inactiveForegroundColor = foregroundColor;
    _noteStemLayer.inactiveForegroundColor = foregroundColor;
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
            layer.activeForegroundColor = self.activeForegroundColor;
            layer.inactiveForegroundColor = self.inactiveForegroundColor;
            [_noteHeadLayers addObject:layer];
            [self addSublayer:layer];
        } else if (auto accidentalGeom = dynamic_cast<const AccidentalGeometry*>(geom.get())) {
            VMKAccidentalLayer* accLayer = [[VMKAccidentalLayer alloc] initWithAccidentalGeometry:accidentalGeom];
            accLayer.activeForegroundColor = self.activeForegroundColor;
            accLayer.inactiveForegroundColor = self.inactiveForegroundColor;
            [_otherLayers addObject:accLayer];
            [self addSublayer:accLayer];
        } else if (auto dotGeom = dynamic_cast<const DotGeometry*>(geom.get())) {
            VMKScoreElementImageLayer* dotView = [[VMKScoreElementImageLayer alloc] initWithImageName:@"dot" geometry:dotGeom];
            dotView.activeForegroundColor = self.activeForegroundColor;
            dotView.inactiveForegroundColor = self.inactiveForegroundColor;
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
        case Articulation::Type::Accent:
            imageName = @"accent";
            break;
        case Articulation::Type::Spiccato:
            imageName = @"spiccato";
            break;

        case Articulation::Type::Staccatissimo:
            imageName = @"staccatissimo";
            break;

        case Articulation::Type::Staccato:
            imageName = @"dot";
            break;

        default:
            imageName = nil;
    }
    if (!imageName)
        return;

    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:imageName geometry:geom];
    if (geom->stem() == dom::Stem::Up)
        layer.affineTransform = CGAffineTransformMakeScale(1, -1);
    [_otherLayers addObject:layer];
    [self addSublayer:layer];
}

- (void)createFermata:(const FermataGeometry*)geom {
    using mxml::dom::Fermata;
    NSString* imageName = @"fermata";
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:imageName geometry:geom];
    if (geom->fermata().type() == Fermata::Type::Inverted)
        layer.affineTransform = CGAffineTransformMakeScale(1, -1);
    [_otherLayers addObject:layer];
    [self addSublayer:layer];
}

- (void)drawInContext:(CGContextRef)ctx{
    auto chordGeometry = self.chordGeometry;
    if (!chordGeometry)
        return;

    auto stemGeometry = chordGeometry->stem();
    if (!stemGeometry)
        return; 

    CGFloat x = chordGeometry->refNoteLocation().x;
    CGFloat miny = chordGeometry->refNoteLocation().y;
    CGFloat maxy = chordGeometry->refNoteLocation().y;
    for (VMKNoteHeadLayer* layer in _noteHeadLayers) {
        CGPoint location = layer.position;
        if (location.y < miny)
            miny = location.y;
        if (location.y > maxy)
            maxy = location.y;
    }

    CGPoint offset = self.bounds.origin;
    CGRect stemRect = CGRectZero;
    if (stemGeometry->stemDirection() == dom::Stem::Up) {
        stemRect.origin.y = offset.y;
        stemRect.origin.x = (x + NoteGeometry::kQuarterWidth/2 - kStemWidth);
        stemRect.size.height = maxy - offset.y - kStemOffset;
    } else if (stemGeometry->stemDirection() == dom::Stem::Down) {
        stemRect.origin.y = miny + kStemOffset;
        stemRect.origin.x = (x - NoteGeometry::kQuarterWidth/2);
        stemRect.size.height = self.preferredFrameSize.height - (miny - offset.y + kStemOffset);
    }
    stemRect.size.width = kStemWidth;

    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);

    CGContextFillRect(ctx, VMKRoundRect(stemRect));
}

@end
