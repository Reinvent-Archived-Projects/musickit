//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
#import <MusicKit/Layers/VMKDirectionLayer.h>
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

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>

    #import <MusicKit/UIKit/NSIndexPath+VMKScoreAdditions.h>
    #import <MusicKit/UIKit/VMKAttributesView.h>
    #import <MusicKit/UIKit/VMKCreditsView.h>
    #import <MusicKit/UIKit/VMKCursorView.h>
    #import <MusicKit/UIKit/VMKMeasureView.h>
    #import <MusicKit/UIKit/VMKScoreElementContainerView.h>
    #import <MusicKit/UIKit/VMKCollectionViewScoreLayout.h>
    #import <MusicKit/UIKit/VMKCollectionViewScoreDataSource.h>
#else
    #import <AppKit/AppKit.h>
#endif
