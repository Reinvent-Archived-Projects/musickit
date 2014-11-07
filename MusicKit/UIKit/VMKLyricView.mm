//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKLyricView.h"


@implementation VMKLyricView

+ (Class)layerClass {
    return[VMKLyricLayer class];
}

- (instancetype)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry {
    return [super initWithGeometry:lyricGeometry];
}

- (VMKLyricLayer*)directionLayer {
    return (VMKLyricLayer*)self.layer;
}

- (const mxml::LyricGeometry*)lyricGeometry {
    return self.directionLayer.lyricGeometry;
}

- (void)setLyricGeometry:(const mxml::LyricGeometry *)lyricGeometry {
    self.directionLayer.lyricGeometry = lyricGeometry;
}

@end
