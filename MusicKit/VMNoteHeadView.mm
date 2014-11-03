//  Created by Alejandro Isaza on 2014-04-04.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMNoteHeadView.h"

using namespace mxml;

@implementation VMNoteHeadView

+ (NSString*)headImageNameForNote:(const dom::Note&)note {
    switch (note.type()) {
        case dom::Note::TYPE_HALF:
            return @"half-head";
            
        case dom::Note::TYPE_WHOLE:
            return @"whole-head";
            
        case dom::Note::TYPE_BREVE:
        case dom::Note::TYPE_LONG:
        case dom::Note::TYPE_MAXIMA:
            return @"breve-head";
            
        default:
            return @"quarter-head";
    }
}

- (id)initWithNoteGeometry:(const NoteGeometry*)noteGeom {
    return [super initWithGeometry:noteGeom];
}

- (const NoteGeometry*)noteGeometry {
    return static_cast<const NoteGeometry*>(self.geometry);
}

- (void)setGeometry:(const Geometry *)geometry {
    const dom::Note& note = static_cast<const NoteGeometry*>(geometry)->note();
    self.imageName = [[self class] headImageNameForNote:note];
    [super setGeometry:geometry];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [super setForegroundColor:foregroundColor];
}

@end
