//  Created by Alejandro Isaza on 2014-04-07.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "ChordGeometry.h"

@class VMNoteHeadView;
@class VMNoteStemView;


/** A view for a set of notes that are played at the same time, and share a stem.
 
 The anchor point of this view is set to the location of the first note in the chord.
 */
@interface VMChordView : VMScoreElementView

- (id)initWithChordGeometry:(const mxml::ChordGeometry*)chordGeom;

@property(nonatomic) const mxml::ChordGeometry* chordGeometry;

@property(nonatomic, strong) NSArray* noteHeadViews;
@property(nonatomic, strong) VMNoteStemView* noteStemView;

@end
