//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#pragma once
#import "TargetConditionals.h" 

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#define VMKColor UIColor

#else

#import <AppKit/AppKit.h>
#define VMKColor NSColor

#endif
