// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKEndingLayer.h"
#import "VMKLyricLayer.h"
#import "VMKMeasureLayer.h"
#import "VMKOctaveShiftLayer.h"
#import "VMKOrnamentLayer.h"
#import "VMKPartLayer.h"
#import "VMKPedalLayer.h"
#import "VMKTieLayer.h"
#import "VMKWedgeLayer.h"
#import "VMKWordsLayer.h"

#include <mxml/dom/OctaveShift.h>
#include <mxml/dom/Pedal.h>
#include <mxml/dom/Wedge.h>
#include <mxml/geometry/CodaGeometry.h>
#include <mxml/geometry/SegnoGeometry.h>


@interface VMKPartLayer ()

@property(nonatomic, strong) NSMutableArray* measureLayers;
@property(nonatomic, strong) NSMutableSet* reusableMeasureLayers;
@property(nonatomic, strong) NSMutableArray* directionLayers;
@property(nonatomic, strong) NSMutableArray* tieLayers;
@property(nonatomic, strong) NSArray* noteColors;

@end


@implementation VMKPartLayer

- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)partGeometry {
    return [super initWithGeometry:partGeometry];
}

- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)partGeometry noteColors:(NSArray *)noteColors {
    self = [super initWithGeometry:partGeometry];
    self.noteColors = noteColors;
    return self;
}

- (void)setup {
    [super setup];
    self.measureLayers = [[NSMutableArray alloc] init];
    self.reusableMeasureLayers = [[NSMutableSet alloc] init];
    self.directionLayers = [[NSMutableArray alloc] init];
    self.tieLayers = [[NSMutableArray alloc] init];
}

#pragma mark - 

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    [super setActiveForegroundColor:foregroundColor];

    for (VMKMeasureLayer* layer in self.measureLayers)
        layer.activeForegroundColor = foregroundColor;
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    [super setInactiveForegroundColor:foregroundColor];

    for (VMKMeasureLayer* layer in self.measureLayers)
        layer.inactiveForegroundColor = foregroundColor;
}

- (void)setNoteColors:(NSArray *)noteColors {
    int i = 0;
    for (VMKMeasureLayer* layer in self.measureLayers) {
        layer.noteColors = noteColors[i];
        i++;
    }
}

- (const mxml::PartGeometry*)partGeometry {
    return static_cast<const mxml::PartGeometry*>(self.geometry);
}

- (void)setPartGeometry:(const mxml::PartGeometry*)partGeometry {
    self.geometry = partGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];

    [self clearSublayers];
    if (geometry)
        [self createSublayers];
    [self setNeedsLayout];
}

- (void)clearSublayers {
    for (VMKMeasureLayer* layer in self.measureLayers) {
        layer.geometry = nullptr;
        layer.hidden = YES;
        [self.reusableMeasureLayers addObject:layer];
    }
    [self.measureLayers removeAllObjects];

    for (VMKScoreElementLayer* layer in self.directionLayers) {
        [layer removeFromSuperlayer];
    }
    [self.directionLayers removeAllObjects];

    for (VMKTieLayer* layer in self.tieLayers) {
        [layer removeFromSuperlayer];
    }
    [self.tieLayers removeAllObjects];
}

- (void)createSublayers {
    auto& measureGeometries = self.partGeometry->measureGeometries();
    for (auto& geometry : measureGeometries) {
        VMKMeasureLayer* layer;
        if (self.reusableMeasureLayers.count > 0) {
            layer = [self.reusableMeasureLayers anyObject];
            [self.reusableMeasureLayers removeObject:layer];
            layer.measureGeometry = geometry;
        } else {
            layer = [[VMKMeasureLayer alloc] initWithMeasure:geometry];
            [self addSublayer:layer];
        }

        layer.activeForegroundColor = self.activeForegroundColor;
        layer.inactiveForegroundColor = self.inactiveForegroundColor;
        layer.backgroundColor = self.backgroundColor;
        layer.hidden = NO;

        [self.measureLayers addObject:layer];
    }

    auto& directionGeometries = self.partGeometry->directionGeometries();
    for (auto& geometry : directionGeometries) {
        [self createDirectionLayer:geometry];
    }

    auto& tieGeometries = self.partGeometry->tieGeometries();
    for (auto& geometry : tieGeometries) {
        [self createTieLayer:geometry];
    }
}

- (void)createDirectionLayer:(const mxml::PlacementGeometry*)geometry {
    VMKScoreElementLayer* layer;

    if (const mxml::SpanDirectionGeometry* geom = dynamic_cast<const mxml::SpanDirectionGeometry*>(geometry)) {
        if (dynamic_cast<const mxml::dom::Wedge*>(geom->type())) {
            layer = [[VMKWedgeLayer alloc] initWithSpanDirectionGeometry:geom];
        } else if (dynamic_cast<const mxml::dom::Pedal*>(geom->type())) {
            layer = [[VMKPedalLayer alloc] initWithSpanDirectionGeometry:geom];
        } else if (dynamic_cast<const mxml::dom::OctaveShift*>(geom->type())) {
            layer = [[VMKOctaveShiftLayer alloc] initWithSpanDirectionGeometry:geom];
        }
    } else if (auto geom = dynamic_cast<const mxml::CodaGeometry*>(geometry)) {
        layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"coda" geometry:geom];
    } else if (auto geom = dynamic_cast<const mxml::SegnoGeometry*>(geometry)) {
        layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"segno" geometry:geom];
    } else if (auto geom = dynamic_cast<const mxml::WordsGeometry*>(geometry)) {
        layer = [[VMKWordsLayer alloc] initWithWordsGeometry:geom];
    } else if (auto geom = dynamic_cast<const mxml::OrnamentsGeometry*>(geometry)) {
        layer = [[VMKOrnamentLayer alloc] initWithOrnamentsGeometry:geom];
    } else if (auto geom = dynamic_cast<const mxml::EndingGeometry*>(geometry)) {
        layer = [[VMKEndingLayer alloc] initWithEndingGeometry:geom];
    } else if (auto geom = dynamic_cast<const mxml::LyricGeometry*>(geometry)) {
        layer = [[VMKLyricLayer alloc] initWithLyricGeometry:geom];
    }

    if (layer) {
        layer.activeForegroundColor = self.activeForegroundColor;
        layer.inactiveForegroundColor = self.inactiveForegroundColor;
        layer.backgroundColor = self.backgroundColor;
        [self addSublayer:layer];
        [self.directionLayers addObject:layer];
    }
}

- (void)createTieLayer:(const mxml::TieGeometry*)geometry {
    VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:geometry];
    layer.activeForegroundColor = self.activeForegroundColor;
    layer.inactiveForegroundColor = self.inactiveForegroundColor;
    layer.backgroundColor = self.backgroundColor;
    [self addSublayer:layer];
    [self.tieLayers addObject:layer];
}

@end
