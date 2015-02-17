//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
