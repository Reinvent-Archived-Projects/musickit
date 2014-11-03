//  Created by Alejandro Isaza on 2014-04-10.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMBeamView.h"
#import "VMChordView.h"
#import "VMDrawing.h"

#include "MeasureGeometry.h"


using mxml::ChordGeometry;
using mxml::BeamGeometry;
using mxml::dom::Beam;

@implementation VMBeamView {
    BOOL _grace;
}

- (id)initWithBeamGeometry:(const BeamGeometry*)beamGeometry {
    return [super initWithGeometry:beamGeometry];
}

- (const BeamGeometry*)beamGeometry {
    return static_cast<const BeamGeometry*>(self.geometry);
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];

    _grace = NO;
    self.transform = CGAffineTransformIdentity;
    if (geometry && !self.beamGeometry->chords().empty()) {
        auto chord = self.beamGeometry->chords().front();
        auto note = chord->chord().firstNote();
        if (note && note->grace()) {
            _grace = YES;
            self.transform = CGAffineTransformMakeScale(1, mxml::MeasureGeometry::kGraceNoteScale);
        }
    }

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.geometry)
        return;
    [self.foregroundColor setFill];
    
    const BeamGeometry* beamGeom = self.beamGeometry;
    CGFloat slope = (beamGeom->beamEnd().y - beamGeom->beamBegin().y) / (beamGeom->beamEnd().x - beamGeom->beamBegin().x);
    
    for (NSUInteger ci = 0; ci < beamGeom->chords().size() - 1; ci += 1) {
        const ChordGeometry* chord1 = beamGeom->chords().at(ci);
        const ChordGeometry* chord2 = beamGeom->chords().at(ci + 1);
        
        CGPoint bb = CGPointFromPoint(beamGeom->stemTip(chord1));
        CGPoint be = CGPointFromPoint(beamGeom->stemTip(chord2));
        NSUInteger nbeams = std::max(chord1->chord().beams().size(), chord2->chord().beams().size());
        for (int bi = 0; bi < nbeams; bi += 1) {
            if (bi < chord1->chord().beams().size()) {
                const Beam& beam = chord1->chord().beams()[bi];
                if (beam.type() == Beam::TYPE_BEGIN || beam.type() == Beam::TYPE_CONTINUE) {
                    [self drawBeamFrom:bb to:be];
                } else if (beam.type() == Beam::TYPE_FORWARD_HOOK) {
                    be.x = bb.x + BeamGeometry::kHookLength;
                    be.y = bb.y - slope * (bb.x - be.x);
                    [self drawBeamFrom:bb to:be];
                }
            }
            if (bi < chord2->chord().beams().size()) {
                const Beam& beam = chord2->chord().beams()[bi];
                if (beam.type() == Beam::TYPE_BACKWARD_HOOK) {
                    bb.x = be.x - BeamGeometry::kHookLength;
                    bb.y = be.y - slope * (be.x - bb.x);
                    [self drawBeamFrom:bb to:be];
                }
            }
            
            if (beamGeom->placement() == mxml::dom::PLACEMENT_BELOW) {
                bb.y += BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
                be.y += BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
            } else {
                bb.y -= BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
                be.y -= BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
            }
        }
    }
}

- (void)drawBeamFrom:(CGPoint)begin to:(CGPoint)end {
    if (_grace) {
        // Adjust to match scaled notes
        begin.x -= 1;
        end.x -= 1;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, begin.x - BeamGeometry::kStemLineWidth/2, begin.y - BeamGeometry::kBeamLineWidth/2);
    CGContextAddLineToPoint(ctx, begin.x - BeamGeometry::kStemLineWidth/2, begin.y + BeamGeometry::kBeamLineWidth/2);
    CGContextAddLineToPoint(ctx, end.x + BeamGeometry::kStemLineWidth/2, end.y + BeamGeometry::kBeamLineWidth/2);
    CGContextAddLineToPoint(ctx, end.x + BeamGeometry::kStemLineWidth/2, end.y - BeamGeometry::kBeamLineWidth/2);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
