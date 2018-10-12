// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKNoteStemLayer.h"
#import "VMKScoreElementLayer.h"
#include <mxml/geometry/ChordGeometry.h>

/** A layer for a set of notes that are played at the same time, and share a stem.

 The anchor point of this layer is set to the location of the first note in the chord.
 */
@interface VMKChordLayer : VMKScoreElementLayer

- (instancetype)initWithChordGeometry:(const mxml::ChordGeometry*)chordGeom;

@property(nonatomic) const mxml::ChordGeometry* chordGeometry;

@property(nonatomic, strong) NSArray* noteHeadViews;
@property(nonatomic, strong) VMKNoteStemLayer* noteStemLayer;
@property(nonatomic, strong) VMKColor* noteHeadColor;

@end
