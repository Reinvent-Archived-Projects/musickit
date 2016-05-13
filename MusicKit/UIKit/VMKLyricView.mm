// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKLyricView.h"


@implementation VMKLyricView

+ (Class)layerClass {
    return [VMKLyricLayer class];
}

- (instancetype)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry {
    return [super initWithGeometry:lyricGeometry];
}

- (VMKLyricLayer*)lyricLayer {
    return (VMKLyricLayer*)self.layer;
}

- (const mxml::LyricGeometry*)lyricGeometry {
    return self.lyricLayer.lyricGeometry;
}

- (void)setLyricGeometry:(const mxml::LyricGeometry *)lyricGeometry {
    self.lyricLayer.lyricGeometry = lyricGeometry;
}

@end
