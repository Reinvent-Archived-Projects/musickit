// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKMeasureLayer.h"
#import "VMKBarlineLayer.h"
#import "VMKBeamLayer.h"
#import "VMKChordLayer.h"
#import "VMKClefLayer.h"
#import "VMKGeometry.h"
#import "VMKImageStore.h"
#import "VMKKeyLayer.h"
#import "VMKNoteHeadLayer.h"
#import "VMKTieLayer.h"
#import "VMKTimeSignatureLayer.h"
#import "VMKTupletLayer.h"
#import "VMKRestLayer.h"

#include <mxml/Metrics.h>
#include <mxml/geometry/BarlineGeometry.h>
#include <mxml/geometry/BeamGeometry.h>
#include <mxml/geometry/ChordGeometry.h>
#include <mxml/geometry/ClefGeometry.h>
#include <mxml/geometry/KeyGeometry.h>
#include <mxml/geometry/TimeSignatureGeometry.h>
#include <mxml/geometry/TupletGeometry.h>

#include <iterator>
#include <limits>
#include <map>

using namespace mxml;
using namespace mxml::dom;

const CGFloat VMKStaffLineWidth = 1.f;
const CGFloat VMKBarLineWidth = 1;


@interface VMKMeasureLayer ()

@property(nonatomic, strong) CATextLayer* numberLayer;

@end


@implementation VMKMeasureLayer {
    NSMutableArray* _elementLayers;
    NSMutableDictionary* _reusableElementViews;
}

- (id)initWithMeasure:(const mxml::MeasureGeometry*)measureGeom {
    return [super initWithGeometry:measureGeom];
}

- (void)setup {
    [super setup];

    _elementLayers = [[NSMutableArray alloc] init];
    _reusableElementViews = [[NSMutableDictionary alloc] init];

    _numberLayer = [CATextLayer layer];
    _numberLayer.contentsScale = VMKScreenScale();
    _numberLayer.anchorPoint = CGPointMake(0, 1);
    _numberLayer.foregroundColor = self.foregroundColor.CGColor;
    _numberLayer.backgroundColor = self.backgroundColor;
    _numberLayer.alignmentMode = kCAAlignmentCenter;
    _numberLayer.font = CFSTR("Baskerville-SemiBold");
    _numberLayer.fontSize = 11;
    _numberLayer.string = @"1";
    _numberLayer.hidden = YES;
#if !TARGET_OS_IPHONE
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DTranslate(t, 0, -_numberLayer.preferredFrameSize.height, 0);
    t = CATransform3DScale(t, 1, -1, 1);
    _numberLayer.transform = t;
#endif
    [self addSublayer:_numberLayer];
}


#pragma mark -

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    [super setActiveForegroundColor:foregroundColor];

    for (VMKScoreElementLayer* view in _elementLayers) {
        if (![view isKindOfClass:[VMKRestLayer class]]) {
            view.activeForegroundColor = foregroundColor;
        }
    }

    _numberLayer.foregroundColor = self.foregroundColor.CGColor;
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    [super setInactiveForegroundColor:foregroundColor];

    for (VMKScoreElementLayer* view in _elementLayers)
        view.inactiveForegroundColor = foregroundColor;

    _numberLayer.foregroundColor = self.foregroundColor.CGColor;
}

- (void)setNoteColors:(NSArray<VMKColor *> *)noteColors {
    int i = 0;
    for (VMKScoreElementLayer* view in _elementLayers) {
        if ([view isKindOfClass:[VMKChordLayer class]] && i < noteColors.count) {
            ((VMKChordLayer *)view).noteHeadColor = noteColors[i];
            i++;
        }
        
        if ([view isKindOfClass:[VMKRestLayer class]] && i < noteColors.count) {
            ((VMKRestLayer *)view).activeForegroundColor = noteColors[i];
            i++;
        }
    }
}

- (const mxml::MeasureGeometry*)measureGeometry {
    return static_cast<const mxml::MeasureGeometry*>(self.geometry);
}

- (void)setMeasureGeometry:(const mxml::MeasureGeometry *)measureGeometry {
    [self setGeometry:measureGeometry];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];

    [self clearElementViews];
    if (geometry) {
        [self createElementViews];
        if (self.measureGeometry->showNumber()) {
            const Measure& measure = self.measureGeometry->measure();
            _numberLayer.string = [NSString stringWithUTF8String:measure.number().c_str()];
            _numberLayer.foregroundColor = self.foregroundColor.CGColor;
            _numberLayer.position = CGPointMake(0, -2);
            _numberLayer.bounds = {CGPointZero, _numberLayer.preferredFrameSize};
            _numberLayer.hidden = NO;
        }
    }

    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)clearElementViews {
    for (VMKScoreElementLayer* layer in _elementLayers) {
        layer.geometry = nullptr;
        layer.hidden = YES;
        NSMutableArray* array = _reusableElementViews[layer.class];
        if (!array) {
            array = [NSMutableArray array];
            _reusableElementViews[layer.class] = array;
        }
        [array addObject:layer];
    }
    [_elementLayers removeAllObjects];

    _numberLayer.hidden = YES;
}

- (void)createElementViews {
    for (auto& geom : self.measureGeometry->geometries()) {
        if (const ClefGeometry* clef = dynamic_cast<const ClefGeometry*>(geom.get())) {
            VMKClefLayer* layer = [self reusableLayerOfClass:[VMKClefLayer class]];
            [self configureView:layer];
            layer.geometry = clef;
            [_elementLayers addObject:layer];
        } else if (const TimeSignatureGeometry* time = dynamic_cast<const TimeSignatureGeometry*>(geom.get())) {
            VMKTimeSignatureLayer* layer = [self reusableLayerOfClass:[VMKTimeSignatureLayer class]];
            [self configureView:layer];
            layer.geometry = time;
            [_elementLayers addObject:layer];
        } else if (const KeyGeometry* key = dynamic_cast<const KeyGeometry*>(geom.get())) {
            VMKKeyLayer* layer = [self reusableLayerOfClass:[VMKKeyLayer class]];
            [self configureView:layer];
            layer.geometry = key;
            [_elementLayers addObject:layer];
        } else if (const BarlineGeometry* barline = dynamic_cast<const BarlineGeometry*>(geom.get())) {
            VMKBarlineLayer* layer = [self reusableLayerOfClass:[VMKBarlineLayer class]];
            [self configureView:layer];
            layer.geometry = barline;
            [_elementLayers addObject:layer];
        } else if (const ChordGeometry* chord = dynamic_cast<const ChordGeometry*>(geom.get())) {
            VMKChordLayer* layer = [self reusableLayerOfClass:[VMKChordLayer class]];
            [self configureView:layer];
            layer.geometry = chord;
            [_elementLayers addObject:layer];
        } else if (const BeamGeometry* beam = dynamic_cast<const BeamGeometry*>(geom.get())) {
            VMKBeamLayer* layer = [self reusableLayerOfClass:[VMKBeamLayer class]];
            [self configureView:layer];
            layer.geometry = beam;
            [_elementLayers addObject:layer];
        } else if (const RestGeometry* rest = dynamic_cast<const RestGeometry*>(geom.get())) {
            VMKRestLayer* layer = [self reusableLayerOfClass:[VMKRestLayer class]];
            [self configureView:layer];
            layer.geometry = rest;
            [_elementLayers addObject:layer];
        } else if (const TupletGeometry* tuplet = dynamic_cast<const TupletGeometry*>(geom.get())) {
            VMKTupletLayer* layer = [self reusableLayerOfClass:[VMKTupletLayer class]];
            [self configureView:layer];
            layer.geometry = tuplet;
            [_elementLayers addObject:layer];
        }
    }
}

- (id)reusableLayerOfClass:(Class)c {
    NSMutableArray* array = _reusableElementViews[c];
    if (array.count > 0) {
        VMKScoreElementLayer* view = [array lastObject];
        [array removeLastObject];
        return view;
    }

    VMKScoreElementLayer* layer = [[c alloc] init];
    [self addSublayer:layer];
    return layer;
}

- (void)configureView:(VMKScoreElementLayer*)layer {
    layer.activeForegroundColor = self.activeForegroundColor;
    layer.inactiveForegroundColor = self.inactiveForegroundColor;
    layer.backgroundColor = self.backgroundColor;
    layer.hidden = NO;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);

    auto& metrics = self.measureGeometry->metrics();
    auto staves = metrics.staves();
    if (staves == 0)
        return;

    CGSize size = self.bounds.size;
    CGFloat staffDistance = metrics.staffDistance();
    CGFloat stavesHeight = metrics.stavesHeight();
    CGRect lineRect;

    // Draw bar lines
    lineRect.origin.x = -VMKBarLineWidth/2;
    lineRect.origin.y = -VMKStaffLineWidth/2;
    lineRect.size.width = VMKBarLineWidth;
    lineRect.size.height = stavesHeight + VMKStaffLineWidth;
    CGContextFillRect(ctx, VMKRoundRect(lineRect));

    lineRect.origin.x = size.width - VMKBarLineWidth/2;
    lineRect.origin.y = -VMKStaffLineWidth/2;
    lineRect.size.width = VMKBarLineWidth;
    lineRect.size.height = stavesHeight + VMKStaffLineWidth;
    CGContextFillRect(ctx, VMKRoundRect(lineRect));

    // Draw staves
    lineRect.origin = CGPointZero;
    lineRect.origin.y -= VMKStaffLineWidth/2;
    lineRect.size.width = size.width;
    lineRect.size.height = VMKStaffLineWidth;
    for (int staff = 1; staff <= staves; staff += 1) {
        for (NSUInteger line = 0; line < Metrics::kStaffLineCount; line += 1) {
            CGContextFillRect(ctx, VMKRoundRect(lineRect));
            lineRect.origin.y += Metrics::kStaffLineSpacing;
        }
        lineRect.origin.y += -Metrics::kStaffLineSpacing + staffDistance;
    }

    // Draw ledger lines
    for (auto& geom : self.geometry->geometries()) {
        if (auto chordGeom = dynamic_cast<ChordGeometry*>(geom.get())) {
            for (auto& noteGeom : chordGeom->notes()) {
                [self drawLedgerLinesForGeometry:noteGeom staffNumber:noteGeom->note().staff() inContext:ctx offset:0];
            }
        } else if (auto restGeom = dynamic_cast<RestGeometry*>(geom.get())) {
            if (restGeom->note().type().isPresent() && restGeom->note().type() < dom::Note::Type::Half)
                continue;

            CGFloat offset = 0;
            if (!restGeom->note().type().isPresent() || restGeom->note().type() >= dom::Note::Type::Whole)
                offset = 10;
            [self drawLedgerLinesForGeometry:restGeom staffNumber:restGeom->note().staff() inContext:ctx offset:offset];
        }
    }
}

- (void)drawLedgerLinesForGeometry:(const MeasureElementGeometry*)noteGeom staffNumber:(int)staff inContext:(CGContextRef)ctx offset:(CGFloat)offset {
    const CGFloat staffOrigin = self.measureGeometry->metrics().staffOrigin(staff);

    CGRect lineRect;
    lineRect.origin = CGPointFromPoint(self.geometry->convertFromGeometry(noteGeom->origin(), noteGeom->parentGeometry()));
    lineRect.origin.x -= 2;
    lineRect.origin.y = staffOrigin - VMKStaffLineWidth/2;
    lineRect.size.width = noteGeom->size().width + 4;
    lineRect.size.height = VMKStaffLineWidth;
    
    CGFloat y = staffOrigin - Metrics::kStaffLineSpacing/2 + offset;
    while (noteGeom->location().y < y) {
        y -= Metrics::kStaffLineSpacing;
        lineRect.origin.y -= Metrics::kStaffLineSpacing;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));
    }
    
    lineRect.origin.y = (staffOrigin + Metrics::staffHeight()) - VMKStaffLineWidth/2;
    y = staffOrigin + Metrics::staffHeight() + Metrics::kStaffLineSpacing/2 + offset;
    while (noteGeom->location().y > y) {
        y += Metrics::kStaffLineSpacing;
        lineRect.origin.y += Metrics::kStaffLineSpacing;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));
    }
}

@end
