// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKNoteStemLayer.h"

using namespace mxml::dom;


@implementation VMKNoteStemLayer

+ (NSString*)stemImageNameForNote:(const mxml::dom::Note&)note direction:(mxml::dom::Stem)stemDirection {
    NSString* name;
    switch (note.type().value()) {
        case Note::Type::_1024th:
        case Note::Type::_512th:
        case Note::Type::_256th:
        case Note::Type::_128th:
            name = @"128th"; break;

        case Note::Type::_64th:
            name = @"64th"; break;

        case Note::Type::_32nd:
            name = @"32nd"; break;

        case Note::Type::_16th:
            name = @"16th"; break;

        case Note::Type::Eighth:
            name = @"eighth"; break;

        case Note::Type::Quarter:
        case Note::Type::Half:
            name = @"quarter"; break;

        default:
            name = nil;
    }
    if (name == nil)
        return nil;

    NSString* dir = nil;
    if (stemDirection == Stem::Up)
        dir = @"up";
    else if (stemDirection == Stem::Down)
        dir = @"down";
    if (dir == nil)
        return nil;

    return [NSString stringWithFormat:@"%@-%@", name, dir];
}

+ (NSString*)noFlagsStemImageNameForNote:(const mxml::dom::Note&)note direction:(mxml::dom::Stem)stemDirection {
    NSString* name = @"quarter";

    NSString* dir = nil;
    if (stemDirection == Stem::Up)
        dir = @"up";
    else if (stemDirection == Stem::Down)
        dir = @"down";
    if (dir == nil)
        return nil;

    return [NSString stringWithFormat:@"%@-%@", name, dir];
}

- (instancetype)initWithStemGeometry:(const mxml::StemGeometry*)stemGeom {
    return [super initWithGeometry:stemGeom];
}

- (const mxml::StemGeometry*)stemGeometry {
    return static_cast<const mxml::StemGeometry*>(self.geometry);
}

- (void)setStemGeometry:(const mxml::StemGeometry*)stemGeometry {
    [self setGeometry:stemGeometry];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    [self updateImage];
}

- (void)updateImage {
    if (self.geometry) {
        const Note& note = self.stemGeometry->note();
        if (self.stemGeometry->showFlags())
            self.imageName = [[self class] stemImageNameForNote:note direction:self.stemGeometry->stemDirection()];
        else
            self.imageName = [[self class] noFlagsStemImageNameForNote:note direction:self.stemGeometry->stemDirection()];
    } else {
        self.imageName = nil;
    }
}

@end
