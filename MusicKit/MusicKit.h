// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

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

#import <MusicKit/Layers/VMKAccidentalLayer.h>
#import <MusicKit/Layers/VMKBarlineLayer.h>
#import <MusicKit/Layers/VMKBeamLayer.h>
#import <MusicKit/Layers/VMKBraceLayer.h>
#import <MusicKit/Layers/VMKChordLayer.h>
#import <MusicKit/Layers/VMKClefLayer.h>
#import <MusicKit/Layers/VMKEndingLayer.h>
#import <MusicKit/Layers/VMKKeyLayer.h>
#import <MusicKit/Layers/VMKLyricLayer.h>
#import <MusicKit/Layers/VMKMeasureLayer.h>
#import <MusicKit/Layers/VMKNoteHeadLayer.h>
#import <MusicKit/Layers/VMKNoteStemLayer.h>
#import <MusicKit/Layers/VMKOrnamentLayer.h>
#import <MusicKit/Layers/VMKPedalLayer.h>
#import <MusicKit/Layers/VMKRestLayer.h>
#import <MusicKit/Layers/VMKScoreElementImageLayer.h>
#import <MusicKit/Layers/VMKScoreElementLayer.h>
#import <MusicKit/Layers/VMKTieLayer.h>
#import <MusicKit/Layers/VMKTimeSignatureLayer.h>
#import <MusicKit/Layers/VMKWedgeLayer.h>
#import <MusicKit/Layers/VMKWordsLayer.h>

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>

    #import <MusicKit/UIKit/NSIndexPath+VMKScoreAdditions.h>
    #import <MusicKit/UIKit/VMKAttributesView.h>
    #import <MusicKit/UIKit/VMKCursorView.h>
    #import <MusicKit/UIKit/VMKMeasureView.h>
    #import <MusicKit/UIKit/VMKScoreElementContainerView.h>
    #import <MusicKit/UIKit/VMKScrollScoreLayout.h>
    #import <MusicKit/UIKit/VMKScrollScoreDataSource.h>
    #import <MusicKit/UIKit/VMKPageScoreLayout.h>
    #import <MusicKit/UIKit/VMKPageScoreDataSource.h>
#else
    #import <AppKit/AppKit.h>
#endif
