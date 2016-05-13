// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <UIKit/UIKit.h>

#include <mxml/geometry/ClefGeometry.h>
#include <mxml/geometry/KeyGeometry.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/TimeSignatureGeometry.h>


@interface VMKAttributesView : UIView

@property(nonatomic) const mxml::PartGeometry* partGeometry;
@property(nonatomic, strong) UIColor* foregroundColor;
@property(nonatomic) CGFloat offset;

- (void)clear;
- (void)addClefGeometry:(const mxml::ClefGeometry*)clef;
- (void)addTimeGeometry:(const mxml::TimeSignatureGeometry*)time;
- (void)addKeyGeometry:(const mxml::KeyGeometry*)key;

@end
