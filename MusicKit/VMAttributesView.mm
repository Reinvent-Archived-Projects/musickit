//  Created by Alejandro Isaza on 2014-05-23.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMAttributesView.h"
#import "VMBraceView.h"
#import "VMClefView.h"
#import "VMDrawing.h"
#import "VMKeyView.h"
#import "VMTimeSignatureView.h"

#include <algorithm>
#include <cassert>
using namespace mxml;

static const CGFloat kLeftMargin = 10;
static const CGFloat kRightMargin = 10;
static const CGFloat kSpacing = 8;
static const CGFloat kDefaultStavesHeight = 145;
static const CGFloat kStaffLineWidth = 1.f;
static const CGFloat kBarLineWidth = 1;
static const CGFloat kGapWidth = 10;


@implementation VMAttributesView {
    VMBraceView* _braceView;
    std::vector<const ClefGeometry*> _clefs;
    std::vector<const TimeSignatureGeometry*> _times;
    std::vector<const KeyGeometry*> _keys;
    
    NSMutableArray* _clefViews;
    NSMutableArray* _timeViews;
    NSMutableArray* _keyViews;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.foregroundColor = [UIColor blackColor];
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder {
    self = [super initWithCoder:decoder];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.foregroundColor = [UIColor blackColor];
    return self;
}

- (void)setPartGeometry:(const mxml::PartGeometry *)partGeometry {
    _partGeometry = partGeometry;

    CGSize size = CGSizeFromSize(partGeometry->size());

    CGRect bounds = self.bounds;
    bounds.origin = VMRoundPoint(CGPointFromPoint(partGeometry->contentOffset()));
    bounds.size.height = size.height;
    self.bounds = bounds;

    [self buildViews];

    _braceView.partGeometry = partGeometry;
    _braceView.hidden = partGeometry->part().staves() <= 1;

    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    
    for (VMClefView *clefView in _clefViews)
        clefView.foregroundColor = _foregroundColor;
    
    for (VMTimeSignatureView *timeView in _timeViews)
        timeView.foregroundColor = _foregroundColor;
    
    for (VMKeyView *keyView in _keyViews)
        keyView.foregroundColor = _foregroundColor;
    
    _braceView.foregroundColor = _foregroundColor;
    
    [self setNeedsDisplay];
}

- (void)clearViews {
    for (UIView* view in _clefViews)
        [view removeFromSuperview];
    for (UIView* view in _timeViews)
        [view removeFromSuperview];
    for (UIView* view in _keyViews)
        [view removeFromSuperview];
    [_braceView removeFromSuperview];
    _braceView = nil;
    
    [_clefViews removeAllObjects];
    [_timeViews removeAllObjects];
    [_keyViews removeAllObjects];
}

- (void)buildViews {
    [self clearViews];
    
    int staves = _partGeometry->part().staves();
    _clefViews = [[NSMutableArray alloc] initWithCapacity:staves];
    _timeViews = [[NSMutableArray alloc] initWithCapacity:staves];
    _keyViews = [[NSMutableArray alloc] initWithCapacity:staves];
    
    for (int staff = 1; staff <= staves; staff += 1) {
        VMClefView* clefView = [[VMClefView alloc] initWithClefGeometry:0];
        clefView.foregroundColor = self.foregroundColor;
        [_clefViews addObject:clefView];
        [self addSubview:clefView];
        
        VMTimeSignatureView* timeView = [[VMTimeSignatureView alloc] initWithTimeSignatureGeometry:0];
        timeView.foregroundColor = self.foregroundColor;
        [_timeViews addObject:timeView];
        [self addSubview:timeView];
        
        VMKeyView* keyView = [[VMKeyView alloc] initWithKeyGeometry:0];
        keyView.foregroundColor = self.foregroundColor;
        [_keyViews addObject:keyView];
        [self addSubview:keyView];
    }
    
    _braceView = [[VMBraceView alloc] initWithPartGeometry:_partGeometry];
    _braceView.foregroundColor = self.foregroundColor;
    [self addSubview:_braceView];
    
    [self setOffset:0];
}

- (void)clear {
    _clefs.clear();
    _times.clear();
    _keys.clear();
}

- (void)addClefGeometry:(const mxml::ClefGeometry*)clef {
    _clefs.push_back(clef);
}

- (void)addTimeGeometry:(const mxml::TimeSignatureGeometry*)time {
    _times.push_back(time);
}

- (void)addKeyGeometry:(const mxml::KeyGeometry*)key {
    _keys.push_back(key);
}

// Select geometries that are behind the offset
- (void)setOffset:(CGFloat)offset {
    if (!_partGeometry)
        return;

    const int staves = _partGeometry->part().staves();
    
    const ClefGeometry* clefGeoms[staves];
    std::fill(clefGeoms, clefGeoms + staves, static_cast<const ClefGeometry*>(0));
    for (auto geom : _clefs) {
        if (clefGeoms[geom->staff() - 1] == 0 || geom->frame().max().x + geom->parentGeometry()->frame().min().x <= offset)
            clefGeoms[geom->staff() - 1] = geom;
    }
    
    const TimeSignatureGeometry* timeGeom = 0;
    for (auto it = _times.rbegin(); it != _times.rend(); ++it) {
        timeGeom = *it;
        if (timeGeom->frame().max().x + timeGeom->parentGeometry()->frame().min().x <= offset)
            break;
    }
    
    const KeyGeometry* keyGeoms[staves];
    std::fill(keyGeoms, keyGeoms + staves, static_cast<const KeyGeometry*>(0));
    for (auto geom : _keys) {
        if (keyGeoms[geom->staff() - 1] == 0 || geom->frame().max().x + geom->parentGeometry()->frame().min().x <= offset)
            keyGeoms[geom->staff() - 1] = geom;
    }
    
    for (int staff = 1; staff <= staves; staff += 1) {
        VMClefView* clefView = _clefViews[staff - 1];
        clefView.geometry = clefGeoms[staff - 1];
        
        VMTimeSignatureView* timeView = _timeViews[staff - 1];
        timeView.geometry = timeGeom;
        
        VMKeyView* keyView = _keyViews[staff - 1];
        keyView.geometry = keyGeoms[staff - 1] ? keyGeoms[staff - 1] : keyGeoms[0];
        if (clefGeoms[staff - 1])
            keyView.clef = &clefGeoms[staff - 1]->clef();
    }

    [self setNeedsLayout];
}

- (CGSize)intrinsicContentSize {
    CGSize size;

    CGFloat clefsWidth = 0;
    for (const ClefGeometry* geom : _clefs) {
        clefsWidth = std::max(clefsWidth, static_cast<CGFloat>(geom->size().width));
    }
    
    CGFloat timesWidth = 0;
    for (const TimeSignatureGeometry* geom : _times) {
        timesWidth = std::max(timesWidth, static_cast<CGFloat>(geom->size().width));
    }
    
    CGFloat keysWidth = 0;
    for (const KeyGeometry* geom : _keys) {
        keysWidth = std::max(keysWidth, static_cast<CGFloat>(geom->size().width));
    }

    size.width = kLeftMargin + _braceView.bounds.size.width + kRightMargin;
    if (clefsWidth > 0)
        size.width += clefsWidth + kSpacing;
    if (timesWidth > 0)
        size.width += timesWidth + kSpacing;
    if (keysWidth > 0)
        size.width += keysWidth + kSpacing;
    
    size.width += kGapWidth;
    
    if (_partGeometry)
        size.height = _partGeometry->size().height;
    else
        size.height = kDefaultStavesHeight + 80;
    
    return size;
}

- (void)layoutSubviews {
    if (!_partGeometry)
        return;
    
    [_braceView sizeToFit];
    _braceView.center = CGPointMake(kLeftMargin, 0);
    CGRect braceFrame = _braceView.frame;

    CGFloat clefsWidth = 0;
    CGFloat timesWidth = 0;
    CGFloat keysWidth = 0;
    
    const int staves = _partGeometry->part().staves();
    for (int staff = 1; staff <= staves; staff += 1) {
        VMClefView* clefView = _clefViews[staff - 1];
        clefsWidth = std::max(clefsWidth, clefView.bounds.size.width);
        
        VMTimeSignatureView* timeView = _timeViews[staff - 1];
        timesWidth = std::max(timesWidth, timeView.bounds.size.width);
        
        VMKeyView* keyView = _keyViews[staff - 1];
        keysWidth = std::max(keysWidth, keyView.bounds.size.width);
    }
    
    CGFloat y0 = -_partGeometry->stavesHeight()/2;
    for (int staff = 1; staff <= staves; staff += 1) {
        CGFloat x = CGRectGetMaxX(braceFrame) + kSpacing;
        CGFloat y = y0 + (_partGeometry->staffOrigin(staff) + _partGeometry->staffHeight()/2);
        
        VMClefView* clefView = _clefViews[staff - 1];
        CGRect clefFrame = clefView.frame;
        clefFrame.origin.x = x;
        clefFrame.origin.y = y - clefFrame.size.height/2;
        clefView.frame = clefFrame;
        x += clefsWidth + kSpacing;
        
        VMTimeSignatureView* timeView = _timeViews[staff - 1];
        CGRect timeFrame = timeView.frame;
        timeFrame.origin.x = x;
        timeFrame.origin.y = y - timeFrame.size.height/2;
        timeView.frame = timeFrame;
        x += timesWidth + kSpacing;
        
        VMKeyView* keyView = _keyViews[staff - 1];
        CGRect keyFrame = keyView.frame;
        keyFrame.origin.x = x;
        keyFrame.origin.y = y - keyFrame.size.height/2;
        keyView.frame = keyFrame;
    }
}

- (void)drawRect:(CGRect)rect {
    if (!_partGeometry)
        return;

    int staves = _partGeometry->part().staves();
    CGFloat staffDistance = _partGeometry->part().staffDistance();
    if (staves == 0)
        return;
    
    CGSize size = self.bounds.size;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat stavesHeight = _partGeometry->stavesHeight();
    CGPoint origin;
    origin.x = CGRectGetMaxX(_braceView.frame) + kSpacing/2;
    origin.y = -_partGeometry->stavesHeight()/2;
    CGRect lineRect;

    [self.foregroundColor setFill];
    
    // Draw bar line
    lineRect.origin = origin;
    lineRect.origin.x -= kBarLineWidth/2;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMRoundRect(lineRect));
    
    // Draw staves
    lineRect.origin = origin;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = size.width - origin.x - kGapWidth;
    lineRect.size.height = kStaffLineWidth;
    for (int staff = 1; staff <= staves; staff += 1) {
        for (NSUInteger line = 0; line < PartGeometry::kStaffLineCount; line += 1) {
            CGContextFillRect(ctx, VMRoundRect(lineRect));
            lineRect.origin.y += PartGeometry::kStaffLineSpacing;
        }
        lineRect.origin.y += -PartGeometry::kStaffLineSpacing + staffDistance;
    }
    
    // Draw bar line
    lineRect.origin = origin;
    lineRect.origin.x = size.width - kGapWidth;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMRoundRect(lineRect));
    
    // Draw bar line
    lineRect.origin = origin;
    lineRect.origin.x = size.width - kStaffLineWidth;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMRoundRect(lineRect));
}

@end
