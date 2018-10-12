// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <Foundation/Foundation.h>

//! Project version number for MusicKit.
FOUNDATION_EXPORT double MusicKitVersionNumber;

//! Project version string for MusicKit.
FOUNDATION_EXPORT const unsigned char MusicKitVersionString[];

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#import <MusicKit/VMKColor.h>
#import <MusicKit/VMKGeometry.h>
#import <MusicKit/VMKImage.h>
#import <MusicKit/VMKImageStore.h>

#import <MusicKit/VMKAccidentalLayer.h>
#import <MusicKit/VMKBarlineLayer.h>
#import <MusicKit/VMKBeamLayer.h>
#import <MusicKit/VMKBraceLayer.h>
#import <MusicKit/VMKChordLayer.h>
#import <MusicKit/VMKClefLayer.h>
#import <MusicKit/VMKEndingLayer.h>
#import <MusicKit/VMKKeyLayer.h>
#import <MusicKit/VMKLyricLayer.h>
#import <MusicKit/VMKMeasureLayer.h>
#import <MusicKit/VMKNoteHeadLayer.h>
#import <MusicKit/VMKNoteStemLayer.h>
#import <MusicKit/VMKOrnamentLayer.h>
#import <MusicKit/VMKPedalLayer.h>
#import <MusicKit/VMKRestLayer.h>
#import <MusicKit/VMKScoreElementImageLayer.h>
#import <MusicKit/VMKScoreElementLayer.h>
#import <MusicKit/VMKTieLayer.h>
#import <MusicKit/VMKTimeSignatureLayer.h>
#import <MusicKit/VMKWedgeLayer.h>
#import <MusicKit/VMKWordsLayer.h>

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>

    #import <MusicKit/NSIndexPath+VMKScoreAdditions.h>
    #import <MusicKit/VMKAttributesView.h>
    #import <MusicKit/VMKCursorView.h>
    #import <MusicKit/VMKMeasureView.h>
    #import <MusicKit/VMKScoreElementContainerView.h>
    #import <MusicKit/VMKScrollScoreLayout.h>
    #import <MusicKit/VMKScrollScoreDataSource.h>
    #import <MusicKit/VMKPageScoreLayout.h>
    #import <MusicKit/VMKPageScoreDataSource.h>
#else
    #import <AppKit/AppKit.h>
#endif
