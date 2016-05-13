// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <CoreGraphics/CoreGraphics.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#define VMKImage UIImage

#else

#import <AppKit/AppKit.h>
#define VMKImage NSImage

@interface NSImage (VMKExtension)

- (NSImageRep*)beestRepresentationForScreenScale;

@end
#endif


CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef));
