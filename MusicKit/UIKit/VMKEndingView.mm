// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKEndingView.h"


@implementation VMKEndingView

+ (Class)layerClass {
    return[VMKEndingLayer class];
}

- (instancetype)initWithEndingGeometry:(const mxml::EndingGeometry*)endingGeometry {
    return [super initWithGeometry:endingGeometry];
}

- (VMKEndingLayer*)endingLayer {
    return (VMKEndingLayer*)self.layer;
}

- (const mxml::EndingGeometry*)endingGeometry {
    return self.endingLayer.endingGeometry;
}

- (void)setEndingGeometry:(const mxml::EndingGeometry *)endingGeometry {
    self.endingLayer.endingGeometry = endingGeometry;
}

@end
