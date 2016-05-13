// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>

extern const CGFloat VMCursorAlpha;
extern const CGFloat VMCursorFadeOutLength;

typedef NS_ENUM(NSInteger, VMKCursorStyle) {
    VMKCursorStyleNone,
    VMKCursorStyleNote,
    VMKCursorStyleMeasure
};


@interface VMKCursorView : UIView

@property(nonatomic, strong) UIColor* color;
@property(nonatomic) CGFloat opacity;
@property(nonatomic) VMKCursorStyle cursorStyle;

@end
