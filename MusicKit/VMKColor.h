// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#pragma once
#import "TargetConditionals.h" 

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#define VMKColor UIColor

#else

#import <AppKit/AppKit.h>
#define VMKColor NSColor

#endif
