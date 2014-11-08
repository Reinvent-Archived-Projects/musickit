//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
