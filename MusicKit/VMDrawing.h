//  Created by Alejandro Isaza on 2014-04-03.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <CoreGraphics/CoreGraphics.h>
#include "Point.h"
#include "Size.h"
#include "Rect.h"

CG_INLINE CGPoint CGPointFromPoint(const mxml::Point& point) {
    return CGPointMake(point.x, point.y);
}

CG_INLINE CGSize CGSizeFromSize(const mxml::Size& size) {
    return CGSizeMake(size.width, size.height);
}

CG_INLINE CGRect CGRectFromRect(const mxml::Rect& rect) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

/** Round a point to the nearest whole pixel.
 
 When placing images and drawing lines it is important to not use half-pixel values or the rendering will be blurry.
 This method will round a point to the nearest pixel, taking into account the screen scale (i.e. retina displays).
 */
CG_EXTERN CGPoint VMRoundPoint(CGPoint point);

/** Round a size to whole pixel values.
 
 When placing images and drawing lines it is important to not use half-pixel values or the rendering will be blurry.
 This method will round a size to the nearest pixel, taking into account the screen scale (i.e. retina display).
 */
CG_EXTERN CGSize VMRoundSize(CGSize size);

/** Round a rectangle so that the edges lie at whole pixels.
 
 When placing images and drawing lines it is important that the edges not lie at half-pixel values or the rendering
 will be blurry. This method will round a rectangle's origin and size so that all edges lie at a whole pixel, taking
 into account the screen scale (i.e. retina displays).
 */
CG_EXTERN CGRect VMRoundRect(CGRect rect);

/** Determine wether a rectangle instersects a line segment.
 */
CG_EXTERN bool VMRectIntersectsLine(CGRect rect, CGPoint p1, CGPoint p2);
