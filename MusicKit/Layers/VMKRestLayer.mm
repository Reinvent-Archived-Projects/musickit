//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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

    self.bounds = {CGPointFromPoint(self.geometry->contentOffset()), size};
    self.position = CGPointFromPoint(self.geometry->location());
}

+ (NSString*)headImageNameForType:(mxml::dom::Note::Type)type {
    switch (type) {
        case Note::TYPE_1024TH:
        case Note::TYPE_512TH:
        case Note::TYPE_256TH:
        case Note::TYPE_128TH:
            return @"128th-rest";

        case Note::TYPE_64TH:
            return @"64th-rest";

        case Note::TYPE_32ND:
            return @"32nd-rest";

        case Note::TYPE_16TH:
            return @"16th-rest";

        case Note::TYPE_EIGHTH:
            return @"eighth-rest";

        case Note::TYPE_QUARTER:
            return @"quarter-rest";

        case Note::TYPE_HALF:
            return @"half-rest";

        case Note::TYPE_WHOLE:
            return @"whole-rest";

        case Note::TYPE_BREVE:
            return @"breve-rest";

        case Note::TYPE_LONG:
            return @"long-rest";

        case Note::TYPE_MAXIMA:
            return @"maxima-rest";
    }
}

- (CGSize)preferredFrameSize {
    return self.image.size;
}

@end
