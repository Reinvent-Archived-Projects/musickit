// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKBeamLayer.h"
#import "VMKChordLayer.h"
#import "VMKGeometry.h"

#include <mxml/geometry/MeasureGeometry.h>

using mxml::ChordGeometry;
using mxml::BeamGeometry;
using mxml::dom::Beam;


@implementation VMKBeamLayer {
    BOOL _grace;
}

- (instancetype)initWithBeamGeometry:(const BeamGeometry*)beamGeometry {
    return [super initWithGeometry:beamGeometry];
}

- (const BeamGeometry*)beamGeometry {
    return static_cast<const BeamGeometry*>(self.geometry);
}

- (void)setBeamGeometry:(const mxml::BeamGeometry*)beamGeometry {
    [self setGeometry:beamGeometry];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];

    _grace = NO;
    self.affineTransform = CGAffineTransformIdentity;
    if (geometry && !self.beamGeometry->chords().empty()) {
        auto chord = self.beamGeometry->chords().front();
        auto note = chord->chord().firstNote();
        if (note && note->grace()) {
            _grace = YES;
            self.affineTransform = CGAffineTransformMakeScale(1, mxml::MeasureGeometry::kGraceNoteScale);
        }
    }

    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    if (!self.geometry)
        return;
    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);

    const BeamGeometry* beamGeom = self.beamGeometry;
    CGFloat slope = beamGeom->slope();

    for (NSUInteger ci = 0; ci < beamGeom->chords().size() - 1; ci += 1) {
        const ChordGeometry* chord1 = beamGeom->chords().at(ci);
        const ChordGeometry* chord2 = beamGeom->chords().at(ci + 1);

        CGPoint bb = CGPointFromPoint(beamGeom->stemTip(chord1));
        CGPoint be = CGPointFromPoint(beamGeom->stemTip(chord2));
        NSUInteger nbeams = std::max(chord1->chord().beams().size(), chord2->chord().beams().size());
        for (int bi = 0; bi < nbeams; bi += 1) {
            if (bi < chord1->chord().beams().size()) {
                const auto& beam = chord1->chord().beams()[bi];
                if (beam->type() == Beam::Type::Begin || beam->type() == Beam::Type::Continue) {
                    [self drawBeamFrom:bb to:be inContext:ctx];
                } else if (beam->type() == Beam::Type::ForwardHook) {
                    be.x = bb.x + BeamGeometry::kHookLength;
                    be.y = bb.y - slope * (bb.x - be.x);
                    [self drawBeamFrom:bb to:be inContext:ctx];
                }
            }
            if (bi < chord2->chord().beams().size()) {
                const auto& beam = chord2->chord().beams()[bi];
                if (beam->type() == Beam::Type::BackwardHook) {
                    bb.x = be.x - BeamGeometry::kHookLength;
                    bb.y = be.y - slope * (be.x - bb.x);
                    [self drawBeamFrom:bb to:be inContext:ctx];
                }
            }

            if (beamGeom->placement() == mxml::dom::Placement::Below) {
                bb.y += BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
                be.y += BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
            } else {
                bb.y -= BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
                be.y -= BeamGeometry::kBeamLineWidth + BeamGeometry::kBeamLineSpacing;
            }
        }
    }
}

- (void)drawBeamFrom:(CGPoint)begin to:(CGPoint)end inContext:(CGContextRef)ctx {
    if (_grace) {
        // Adjust to match scaled notes
        begin.x -= 1;
        end.x -= 1;
    }

    CGContextMoveToPoint(ctx, begin.x - BeamGeometry::kStemLineWidth/2, begin.y - BeamGeometry::kBeamLineWidth/2);
    CGContextAddLineToPoint(ctx, begin.x - BeamGeometry::kStemLineWidth/2, begin.y + BeamGeometry::kBeamLineWidth/2);
    CGContextAddLineToPoint(ctx, end.x + BeamGeometry::kStemLineWidth/2, end.y + BeamGeometry::kBeamLineWidth/2);
    CGContextAddLineToPoint(ctx, end.x + BeamGeometry::kStemLineWidth/2, end.y - BeamGeometry::kBeamLineWidth/2);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
