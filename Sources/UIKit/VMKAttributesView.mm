// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAttributesView.h"
#import "VMKBraceLayer.h"
#import "VMKClefLayer.h"
#import "VMKGeometry.h"
#import "VMKKeyLayer.h"
#import "VMKTimeSignatureLayer.h"

#import <mxml/Metrics.h>

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


@implementation VMKAttributesView {
    VMKBraceLayer* _braceLayer;
    std::vector<const ClefGeometry*> _clefs;
    std::vector<const TimeSignatureGeometry*> _times;
    std::vector<const KeyGeometry*> _keys;
    
    NSMutableArray* _clefLayers;
    NSMutableArray* _timeLayers;
    NSMutableArray* _keyLayers;
    
    BOOL _updateGeometries;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.foregroundColor = [UIColor blackColor];
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)decoder {
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
    bounds.origin = VMKRoundPoint(CGPointFromPoint(partGeometry->contentOffset()));
    bounds.size.height = size.height;
    self.bounds = bounds;

    [self buildLayers];

    _braceLayer.partGeometry = partGeometry;
    _braceLayer.hidden = partGeometry->staves() <= 1;

    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    
    for (VMKClefLayer *clefLayer in _clefLayers)
        clefLayer.activeForegroundColor = _foregroundColor;
    
    for (VMKTimeSignatureLayer *timeLayer in _timeLayers)
        timeLayer.activeForegroundColor = _foregroundColor;
    
    for (VMKKeyLayer *keyLayer in _keyLayers)
        keyLayer.activeForegroundColor = _foregroundColor;
    
    _braceLayer.activeForegroundColor = _foregroundColor;
    
    [self setNeedsDisplay];
}

- (void)clearLayers {
    for (UIView* view in _clefLayers)
        [view removeFromSuperview];
    for (UIView* view in _timeLayers)
        [view removeFromSuperview];
    for (UIView* view in _keyLayers)
        [view removeFromSuperview];
    [_braceLayer removeFromSuperlayer];
    _braceLayer = nil;
    
    [_clefLayers removeAllObjects];
    [_timeLayers removeAllObjects];
    [_keyLayers removeAllObjects];
}

- (void)buildLayers {
    [self clearLayers];
    
    auto staves = _partGeometry->staves();
    _clefLayers = [[NSMutableArray alloc] initWithCapacity:staves];
    _timeLayers = [[NSMutableArray alloc] initWithCapacity:staves];
    _keyLayers = [[NSMutableArray alloc] initWithCapacity:staves];
    
    for (int staff = 1; staff <= staves; staff += 1) {
        VMKClefLayer* clefLayer = [[VMKClefLayer alloc] initWithClefGeometry:0];
        clefLayer.activeForegroundColor = self.foregroundColor;
        [_clefLayers addObject:clefLayer];
        [self.layer addSublayer:clefLayer];
        
        VMKTimeSignatureLayer* timeLayer = [[VMKTimeSignatureLayer alloc] initWithTimeSignatureGeometry:0];
        timeLayer.activeForegroundColor = self.foregroundColor;
        [_timeLayers addObject:timeLayer];
        [self.layer addSublayer:timeLayer];
        
        VMKKeyLayer* keyLayer = [[VMKKeyLayer alloc] initWithKeyGeometry:0];
        keyLayer.activeForegroundColor = self.foregroundColor;
        keyLayer.hideNaturals = YES;
        [_keyLayers addObject:keyLayer];
        [self.layer addSublayer:keyLayer];
    }
    
    _braceLayer = [[VMKBraceLayer alloc] initWithPartGeometry:_partGeometry];
    _braceLayer.activeForegroundColor = self.foregroundColor;
    [self.layer addSublayer:_braceLayer];
    
    _updateGeometries = YES;
}

- (void)clear {
    _clefs.clear();
    _times.clear();
    _keys.clear();
}

- (void)addClefGeometry:(const mxml::ClefGeometry*)clef {
    _clefs.push_back(clef);
    _updateGeometries = YES;
}

- (void)addTimeGeometry:(const mxml::TimeSignatureGeometry*)time {
    _times.push_back(time);
    _updateGeometries = YES;
}

- (void)addKeyGeometry:(const mxml::KeyGeometry*)key {
    _keys.push_back(key);
    _updateGeometries = YES;
}

- (void)updateGeometries {
    if (!_updateGeometries)
        return;
    
    if (!_partGeometry)
        return;
    
    const auto staves = _partGeometry->staves();
    
    const ClefGeometry* clefGeoms[staves];
    std::fill(clefGeoms, clefGeoms + staves, static_cast<const ClefGeometry*>(0));
    for (auto& geom : _clefs) {
        // Select geometries that are behind the offset
        if (clefGeoms[geom->staff() - 1] == 0 || geom->frame().max().x + geom->parentGeometry()->frame().min().x <= _offset)
            clefGeoms[geom->staff() - 1] = geom;
    }
    
    const TimeSignatureGeometry* timeGeom = 0;
    for (auto it = _times.rbegin(); it != _times.rend(); ++it) {
        timeGeom = *it;
        if (timeGeom->frame().max().x + timeGeom->parentGeometry()->frame().min().x <= _offset)
            break;
    }
    
    const KeyGeometry* keyGeoms[staves];
    std::fill(keyGeoms, keyGeoms + staves, static_cast<const KeyGeometry*>(0));
    for (auto& geom : _keys) {
        // Select geometries that are behind the offset
        if (keyGeoms[geom->staff() - 1] == 0 || geom->frame().max().x + geom->parentGeometry()->frame().min().x <= _offset)
            keyGeoms[geom->staff() - 1] = geom;
    }
    
    for (int staff = 1; staff <= staves; staff += 1) {
        VMKClefLayer* clefLayer = _clefLayers[staff - 1];
        clefLayer.geometry = clefGeoms[staff - 1];
        
        VMKTimeSignatureLayer* timeLayer = _timeLayers[staff - 1];
        timeLayer.geometry = timeGeom;
        
        VMKKeyLayer* keyLayer = _keyLayers[staff - 1];
        keyLayer.geometry = keyGeoms[staff - 1] ? keyGeoms[staff - 1] : keyGeoms[0];
        if (clefGeoms[staff - 1])
            keyLayer.clef = &clefGeoms[staff - 1]->clef();
    }
    
    [self setNeedsLayout];
    _updateGeometries = NO;
}

- (void)setOffset:(CGFloat)offset {
    if (_offset != offset) {
        _offset = offset;
        _updateGeometries = YES;
        [self setNeedsLayout];
    }
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

    size.width = kLeftMargin + _braceLayer.bounds.size.width + kRightMargin;
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
    [self updateGeometries];
    
    if (!_partGeometry)
        return;
    
    _braceLayer.bounds = {CGPointZero, _braceLayer.preferredFrameSize};
    _braceLayer.position = CGPointMake(kLeftMargin, _partGeometry->stavesHeight()/2);
    CGRect braceFrame = _braceLayer.frame;

    CGFloat clefsWidth = 0;
    CGFloat timesWidth = 0;
    CGFloat keysWidth = 0;
    
    const auto staves = _partGeometry->staves();
    for (int staff = 1; staff <= staves; staff += 1) {
        VMKClefLayer* clefLayer = _clefLayers[staff - 1];
        clefsWidth = std::max(clefsWidth, clefLayer.bounds.size.width);
        
        VMKTimeSignatureLayer* timeLayer = _timeLayers[staff - 1];
        timesWidth = std::max(timesWidth, timeLayer.bounds.size.width);
        
        VMKKeyLayer* keyLayer = _keyLayers[staff - 1];
        keysWidth = std::max(keysWidth, keyLayer.bounds.size.width);
    }
    
    CGFloat y0 = 0;
    for (int staff = 1; staff <= staves; staff += 1) {
        CGFloat x = CGRectGetMaxX(braceFrame) + kSpacing;
        CGFloat y = y0 + (_partGeometry->staffOrigin(staff) + Metrics::staffHeight()/2);
        
        VMKClefLayer* clefLayer = _clefLayers[staff - 1];
        CGRect clefFrame = clefLayer.frame;
        clefFrame.origin.x = x;
        clefFrame.origin.y = y - clefFrame.size.height/2;
        clefLayer.frame = clefFrame;
        x += clefsWidth + kSpacing;
        
        VMKTimeSignatureLayer* timeLayer = _timeLayers[staff - 1];
        CGRect timeFrame = timeLayer.frame;
        timeFrame.origin.x = x;
        timeFrame.origin.y = y - timeFrame.size.height/2;
        timeLayer.frame = timeFrame;
        x += timesWidth + kSpacing;
        
        VMKKeyLayer* keyLayer = _keyLayers[staff - 1];
        CGRect keyFrame = keyLayer.frame;
        keyFrame.origin.x = x;
        keyFrame.origin.y = y - keyFrame.size.height/2;
        keyLayer.frame = keyFrame;
    }
}

- (void)drawRect:(CGRect)rect {
    if (!_partGeometry)
        return;

    const auto staves = _partGeometry->staves();
    CGFloat staffDistance = _partGeometry->staffDistance();
    if (staves == 0)
        return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize size = self.bounds.size;

    CGFloat stavesHeight = _partGeometry->stavesHeight();
    CGPoint origin;
    origin.x = CGRectGetMaxX(_braceLayer.frame) + kSpacing/2;
    origin.y = 0;
    CGRect lineRect;

    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);
    
    // Draw bar line
    lineRect.origin = origin;
    lineRect.origin.x -= kBarLineWidth/2;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMKRoundRect(lineRect));
    
    // Draw staves
    lineRect.origin = origin;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = size.width - origin.x - kGapWidth;
    lineRect.size.height = kStaffLineWidth;
    for (int staff = 1; staff <= staves; staff += 1) {
        for (NSUInteger line = 0; line < Metrics::kStaffLineCount; line += 1) {
            CGContextFillRect(ctx, VMKRoundRect(lineRect));
            lineRect.origin.y += Metrics::kStaffLineSpacing;
        }
        lineRect.origin.y += -Metrics::kStaffLineSpacing + staffDistance;
    }
    
    // Draw bar line
    lineRect.origin = origin;
    lineRect.origin.x = size.width - kGapWidth;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMKRoundRect(lineRect));
    
    // Draw bar line
    lineRect.origin = origin;
    lineRect.origin.x = size.width - kStaffLineWidth;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMKRoundRect(lineRect));
}

@end
