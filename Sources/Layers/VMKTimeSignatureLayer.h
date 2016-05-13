// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKScoreElementLayer.h"
#include <mxml/geometry/TimeSignatureGeometry.h>


@interface VMKTimeSignatureLayer : VMKScoreElementLayer

/**
 Get the image for a time signature symbol at a particular scale.
 */
+ (VMKImage*)imageForSymbol:(mxml::dom::Time::Symbol)symbol withColor:(VMKColor*)color;

/**
 Get the array of digit images for a time signature number.
 */
+ (NSArray*)imagesForNumber:(int)number withColor:(VMKColor*)color;

/**
 Get the image for a time signature digit at a particular scale.
 */
+ (VMKImage*)imageForDigit:(int)digit withColor:(VMKColor*)color;


- (instancetype)initWithTimeSignatureGeometry:(const mxml::TimeSignatureGeometry*)timeGeom;

@property(nonatomic) const mxml::TimeSignatureGeometry* timeSignatureGeometry;

@end
