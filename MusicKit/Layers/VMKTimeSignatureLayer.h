//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
