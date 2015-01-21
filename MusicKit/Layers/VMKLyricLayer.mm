//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKGeometry.h"
#import "VMKLyricLayer.h"


@implementation VMKLyricLayer

- (instancetype)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry {
    return [super initWithGeometry:lyricGeometry];
}

- (void)setup {
    [super setup];

    _textLayer = [CATextLayer layer];
    _textLayer.foregroundColor = self.foregroundColor;
    _textLayer.backgroundColor = self.backgroundColor;
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.contentsScale = VMKScreenScale();
#if !TARGET_OS_IPHONE
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DTranslate(t, 0, -_textLayer.preferredFrameSize.height, 0);
    t = CATransform3DScale(t, 1, -1, 1);
    _textLayer.transform = t;
#endif
    [self addSublayer:_textLayer];
}

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    [super setForegroundColor:foregroundColor];
    _textLayer.foregroundColor = foregroundColor;
}

- (const mxml::LyricGeometry*)lyricGeometry {
    return static_cast<const mxml::LyricGeometry*>(self.geometry);
}

- (void)setLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry {
    self.geometry = lyricGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];

    const mxml::dom::Lyric& lyric = self.lyricGeometry->lyric();
    _textLayer.font = (CFTypeRef)@"Baskerville";
    _textLayer.fontSize = 20;

    NSString* string  = [NSString stringWithUTF8String:lyric.text().c_str()];

    if (lyric.syllabic()) {
        mxml::dom::Syllabic::Type type = lyric.syllabic()->type();
        if (type == mxml::dom::Syllabic::kBegin || type == mxml::dom::Syllabic::kMiddle)
            string = [string stringByAppendingString:@" - "];
    }
    
    _textLayer.string = string;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    CGSize size = self.bounds.size;
    _textLayer.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
