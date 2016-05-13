// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKGeometry.h"
#import "VMKLyricLayer.h"


@implementation VMKLyricLayer

- (instancetype)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry {
    return [super initWithGeometry:lyricGeometry];
}

- (void)setup {
    [super setup];

    _textLayer = [CATextLayer layer];
    _textLayer.foregroundColor = self.foregroundColor.CGColor;
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

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    [super setActiveForegroundColor:foregroundColor];
    _textLayer.foregroundColor = self.foregroundColor.CGColor;
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    [super setInactiveForegroundColor:foregroundColor];
    _textLayer.foregroundColor = self.foregroundColor.CGColor;
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
    _textLayer.fontSize = 18;

    NSString* string  = [NSString stringWithUTF8String:lyric.text().c_str()];

    if (lyric.syllabic()) {
        mxml::dom::Syllabic::Type type = lyric.syllabic()->type();
        if (type == mxml::dom::Syllabic::Type::Begin || type == mxml::dom::Syllabic::Type::Middle)
            string = [string stringByAppendingString:@" - "];
    }

    _textLayer.foregroundColor = self.foregroundColor.CGColor;
    _textLayer.string = string;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    CGSize size = self.bounds.size;
    _textLayer.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
