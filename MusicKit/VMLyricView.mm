//  Created by Alejandro Isaza on 2014-07-22.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMLyricView.h"

@implementation VMLyricView

- (id)initWithLyricGeometry:(const mxml::LyricGeometry*)lyricGeometry {
    return [super initWithGeometry:lyricGeometry];
}

- (void)setup {
    [super setup];

    _label = [[UILabel alloc] init];
    _label.textColor = self.foregroundColor;
    _label.backgroundColor = self.backgroundColor;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [super setForegroundColor:foregroundColor];
    _label.textColor = self.foregroundColor;
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
    _label.font = [UIFont fontWithName:@"Baskerville" size:20];

    NSString* string  = [NSString stringWithUTF8String:lyric.text().c_str()];

    mxml::dom::Syllabic::Type type = lyric.syllabic().value().type();
    if (type == mxml::dom::Syllabic::Begin || type == mxml::dom::Syllabic::Middle)
        string = [string stringByAppendingString:@" - "];
    _label.text = string;
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    _label.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
