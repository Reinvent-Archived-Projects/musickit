//  Created by Alejandro Isaza on 2014-04-04.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementImageView.h"
#include "NoteGeometry.h"

@interface VMNoteHeadView : VMScoreElementImageView

/**
 Get the image for the note head of the given type at a particlar scale.
 */
+ (NSString*)headImageNameForNote:(const mxml::dom::Note&)note;

- (id)initWithNoteGeometry:(const mxml::NoteGeometry*)noteGeom;

- (const mxml::NoteGeometry*)noteGeometry;

@end
