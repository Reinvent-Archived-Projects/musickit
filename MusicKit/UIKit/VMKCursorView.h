//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
