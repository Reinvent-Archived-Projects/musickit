//  Created by Alejandro Isaza on 2014-04-03.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#import "VMDrawing.h"

CG_EXTERN CGFloat VMRoundCoordinate(CGFloat coord) {
    if (coord < 0)
        return roundf(coord + 0.5f);
    return roundf(coord);
}

CG_EXTERN CGPoint VMRoundPoint(CGPoint point) {
    CGFloat scale = [UIScreen mainScreen].scale;
    point.x = VMRoundCoordinate(scale * point.x) / scale;
    point.y = VMRoundCoordinate(scale * point.y) / scale;
    return point;
}

CG_EXTERN CGSize VMRoundSize(CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width = VMRoundCoordinate(scale * size.width) / scale;
    size.height = VMRoundCoordinate(scale * size.height) / scale;
    return size;
}

CG_EXTERN CGRect VMRoundRect(CGRect rect) {
    rect.origin = VMRoundPoint(rect.origin);
    rect.size = VMRoundSize(rect.size);
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
