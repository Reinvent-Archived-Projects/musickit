// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKWordsLayer.h"
#import "VMKGeometry.h"
#import "VMKColor.h"


@implementation VMKWordsLayer

- (instancetype)initWithWordsGeometry:(const mxml::WordsGeometry*)wordsGeom {
    return [super initWithGeometry:wordsGeom];
}

- (void)setup {
    [super setup];

    _textLayer = [CATextLayer layer];
    _textLayer.foregroundColor = self.foregroundColor.CGColor;
    _textLayer.backgroundColor = self.backgroundColor;
    _textLayer.alignmentMode = kCAAlignmentLeft;
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

- (const mxml::WordsGeometry*)wordsGeometry {
    return static_cast<const mxml::WordsGeometry*>(self.geometry);
}

- (void)setDirectionGeometry:(const mxml::WordsGeometry*)wordsGeometry {
    [self setGeometry:wordsGeometry];
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];
    
    NSString *preprend = @"";
    if (self.wordsGeometry->dynamics()) {
        _textLayer.font = CFSTR("Baskerville-BoldItalic");
        _textLayer.fontSize = 26;
        _textLayer.alignmentMode = kCAAlignmentCenter;
    } else {
        _textLayer.font = CFSTR("Baskerville-SemiBold");
        _textLayer.fontSize = 20;
        _textLayer.alignmentMode = kCAAlignmentLeft;
    }
    
    if (self.wordsGeometry->contents())
        _textLayer.string = [preprend stringByAppendingString:[NSString stringWithUTF8String:self.wordsGeometry->contents()->c_str()]];

    _textLayer.foregroundColor = self.foregroundColor.CGColor;
    _textLayer.frame = {CGPointZero, self.bounds.size};
}

- (void)layoutSublayers {
    [super layoutSublayers];
    _textLayer.frame = {CGPointZero, self.bounds.size};
}

@end
