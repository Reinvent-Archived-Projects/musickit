// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKGeometry.h"
#import "VMKRestLayer.h"

using namespace mxml::dom;


@implementation VMKRestLayer

- (instancetype)initWithRestGeometry:(const mxml::RestGeometry*)restGeom {
    return [super initWithGeometry:restGeom];
}

- (const mxml::RestGeometry*)restGeometry {
    return static_cast<const mxml::RestGeometry*>(self.geometry);
}

- (void)setRestGeometry:(const mxml::RestGeometry *)restGeometry {
    self.geometry = restGeometry;
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    const mxml::RestGeometry* restGeometry = static_cast<const mxml::RestGeometry*>(geometry);
    if (geometry) {
        self.imageName = [[self class] headImageNameForType:restGeometry->note().type()];
    } else {
        self.imageName = nil;
    }

    [super setGeometry:geometry];
    if (!self.geometry)
        return;

    CGSize size = self.preferredFrameSize;
    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    if (size.width > 0 && size.height > 0) {
        mxml::Point point = self.geometry->anchorPoint({static_cast<float>(size.width), static_cast<float>(size.height)});
        anchorPoint = CGPointMake(point.x / size.width, point.y / size.height);
    }
    self.anchorPoint = anchorPoint;

    self.bounds = VMKRoundRect({CGPointFromPoint(self.geometry->contentOffset()), size});
    self.position = CGPointFromPoint(self.geometry->location());
    self.frame = VMKRoundRect(self.frame);
}

+ (NSString*)headImageNameForType:(mxml::dom::Optional<mxml::dom::Note::Type>)type {
    if (!type.isPresent())
        return @"whole-rest";

    switch (type.value()) {
        case Note::Type::_1024th:
        case Note::Type::_512th:
        case Note::Type::_256th:
        case Note::Type::_128th:
            return @"128th-rest";

        case Note::Type::_64th:
            return @"64th-rest";

        case Note::Type::_32nd:
            return @"32nd-rest";

        case Note::Type::_16th:
            return @"16th-rest";

        case Note::Type::Eighth:
            return @"eighth-rest";

        case Note::Type::Quarter:
            return @"quarter-rest";

        case Note::Type::Half:
            return @"half-rest";

        case Note::Type::Whole:
            return @"whole-rest";

        case Note::Type::Breve:
            return @"breve-rest";

        case Note::Type::Long:
            return @"long-rest";

        case Note::Type::Maxima:
            return @"maxima-rest";
    }
}

- (CGSize)preferredFrameSize {
    return self.image.size;
}

@end
