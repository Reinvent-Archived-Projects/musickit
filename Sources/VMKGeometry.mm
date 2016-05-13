// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import <CoreGraphics/CoreGraphics.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "VMKGeometry.h"
#include <cmath>


CG_EXTERN CGFloat VMKScreenScale() {
#if TARGET_OS_IPHONE
    return [UIScreen mainScreen].scale;
#else
    return [NSScreen mainScreen].backingScaleFactor;
#endif
}

CG_EXTERN CGFloat VMKRoundCoordinate(CGFloat coord) {
    if (coord < 0)
        return std::roundf(coord + 0.1f);
    return std::roundf(coord);
}

CG_EXTERN CGPoint VMKRoundPoint(CGPoint point) {
    CGFloat scale;
#if TARGET_OS_IPHONE
    scale = [UIScreen mainScreen].scale;
#else
    scale = [NSScreen mainScreen].backingScaleFactor;
#endif
    point.x = VMKRoundCoordinate(scale * point.x) / scale;
    point.y = VMKRoundCoordinate(scale * point.y) / scale;
    return point;
}

CG_EXTERN CGSize VMKRoundSize(CGSize size) {
    CGFloat scale;
#if TARGET_OS_IPHONE
    scale = [UIScreen mainScreen].scale;
#else
    scale = [NSScreen mainScreen].backingScaleFactor;
#endif
    size.width = ceil(scale * size.width) / scale;
    size.height = ceil(scale * size.height) / scale;
    return size;
}

CG_EXTERN CGRect VMKRoundRect(CGRect rect) {
    rect.origin = VMKRoundPoint(rect.origin);
    rect.size = VMKRoundSize(rect.size);
    return rect;
}

CG_EXTERN bool VMLineSegmentsIntersect(CGPoint p0, CGPoint p1, CGPoint q0, CGPoint q1) {
    CGPoint dp = {p1.x - p0.x, p1.y - p0.y};
    CGPoint dq = {q1.x - q0.x, q1.y - q0.y};
    CGFloat det = dq.x*dp.y - dp.x*dq.y;
    if (det == 0)
        return false;
    
    CGPoint d0 = {p0.x - q0.x, p0.y - q0.y};
    CGFloat t = (d0.x * dq.y - dq.x*d0.y) / det;
    CGFloat s = (-dp.x * d0.y + d0.x*dp.y) / det;
    return t >= 0 && t <= 1 && s >= 0 && s <= 1;
}

CG_EXTERN bool VMRectIntersectsLine(CGRect rect, CGPoint p1, CGPoint p2) {
    if (CGRectContainsPoint(rect, p1) || CGRectContainsPoint(rect, p2))
        return true;
    
    CGPoint points[] = {
        {CGRectGetMinX(rect), CGRectGetMinY(rect)},
        {CGRectGetMaxX(rect), CGRectGetMinY(rect)},
        {CGRectGetMaxX(rect), CGRectGetMaxY(rect)},
        {CGRectGetMinX(rect), CGRectGetMaxY(rect)}
    };
    return
        VMLineSegmentsIntersect(points[0], points[1], p1, p2) ||
        VMLineSegmentsIntersect(points[1], points[2], p1, p2) ||
        VMLineSegmentsIntersect(points[2], points[3], p1, p2) ||
        VMLineSegmentsIntersect(points[3], points[0], p1, p2);
}
