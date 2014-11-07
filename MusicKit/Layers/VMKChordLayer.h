//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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

@end
