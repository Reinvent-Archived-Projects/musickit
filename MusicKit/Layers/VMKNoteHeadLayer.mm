//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKNoteHeadLayer.h"

using namespace mxml;


@implementation VMKNoteHeadLayer

+ (NSString*)headImageNameForNote:(const dom::Note&)note {
    switch (note.type().value()) {
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

- (instancetype)initWithNoteGeometry:(const NoteGeometry*)noteGeom {
    return [super initWithGeometry:noteGeom];
}

- (const NoteGeometry*)noteGeometry {
    return static_cast<const NoteGeometry*>(self.geometry);
}

- (void)setNoteGeometry:(const mxml::NoteGeometry*)noteGeometry {
    [self setGeometry:noteGeometry];
}

- (void)setGeometry:(const Geometry *)geometry {
    const dom::Note& note = static_cast<const NoteGeometry*>(geometry)->note();
    self.imageName = [[self class] headImageNameForNote:note];
    [super setGeometry:geometry];
}

@end
