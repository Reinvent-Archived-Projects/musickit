//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementView.h"
#include "TimeSignatureGeometry.h"


@interface VMTimeSignatureView : VMScoreElementView

/**
 Get the image for a time signature symbol at a particular scale.
 */
+ (UIImage*)imageForSymbol:(mxml::dom::Time::Symbol)symbol;

/**
 Get the array of digit images for a time signature number.
 */
+ (NSArray*)imagesForNumber:(int)number;

/**
 Get the image for a time signature digit at a particular scale.
 */
+ (UIImage*)imageForDigit:(int)digit;


- (id)initWithTimeSignatureGeometry:(const mxml::TimeSignatureGeometry*)timeGeom;

- (const mxml::TimeSignatureGeometry*)timeSignatureGeometry;

@end
