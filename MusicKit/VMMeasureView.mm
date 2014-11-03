//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMMeasureView.h"
#import "VMBarlineView.h"
#import "VMBeamView.h"
#import "VMChordView.h"
#import "VMClefView.h"
#import "VMDrawing.h"
#import "VMImageStore.h"
#import "VMKeyView.h"
#import "VMNoteHeadView.h"
#import "VMTieView.h"
#import "VMTimeSignatureView.h"
#import "VMRestView.h"

#include "BarlineGeometry.h"
#include "BeamGeometry.h"
#include "ChordGeometry.h"
#include "ClefGeometry.h"
#include "KeyGeometry.h"
#include "TimeSignatureGeometry.h"

#include <iterator>
#include <limits>
#include <map>

using namespace mxml;
using namespace mxml::dom;

static const CGFloat kStaffLineWidth = 1.f;
static const CGFloat kBarLineWidth = 1;
static const NSTimeInterval kAnimationDuration = 0.5;


@interface VMMeasureView ()

@property(nonatomic, strong) UILabel* numberLabel;
@property(nonatomic, strong) UILabel* bookmarkedNumberLabel;
@property(nonatomic, strong) UIImageView* bookmarkImageView;

@end


@implementation VMMeasureView {
    NSMutableArray* _elementViews;
    NSMutableDictionary* _reusableElementViews;
}

- (id)initWithMeasure:(const mxml::MeasureGeometry*)measureGeom {
    return [super initWithGeometry:measureGeom];
}

- (void)setup {
    [super setup];
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    _elementViews = [[NSMutableArray alloc] init];
    _reusableElementViews = [[NSMutableDictionary alloc] init];

    _numberLabel = [[UILabel alloc] init];
    _numberLabel.layer.anchorPoint = CGPointMake(0, 1);
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.textColor = self.foregroundColor;
    _numberLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:11];
    _numberLabel.text = @"1";
    [self addSubview:_numberLabel];

    _bookmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-bookmark"]];
    _bookmarkImageView.layer.anchorPoint = CGPointMake(0, 1);
    _bookmarkImageView.hidden = YES;
    [self addSubview:_bookmarkImageView];

    _bookmarkedNumberLabel = [[UILabel alloc] init];
    _bookmarkedNumberLabel.layer.anchorPoint = CGPointMake(0, 1);
    _bookmarkedNumberLabel.textAlignment = NSTextAlignmentCenter;
    _bookmarkedNumberLabel.textColor = [UIColor whiteColor];
    _bookmarkedNumberLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:11];
    _bookmarkedNumberLabel.text = @"1";
    _bookmarkedNumberLabel.hidden = YES;
    [self addSubview:_bookmarkedNumberLabel];
}


#pragma mark - Bookmakrs

- (void)setBookmarked:(BOOL)bookmarked {
    [self setBookmarked:bookmarked animated:NO];
}

- (void)setBookmarked:(BOOL)bookmarked animated:(BOOL)animated {
    static const CGFloat kMinimumScale = 0.2;
    static const CGAffineTransform kMinimumScaleTransform = CGAffineTransformMakeScale(kMinimumScale, kMinimumScale);

    _bookmarked = bookmarked;

    if (bookmarked) {
        _bookmarkImageView.hidden = NO;
        _bookmarkedNumberLabel.hidden = NO;

        void (^setupBlock)() = ^() {
            _bookmarkImageView.alpha = 0;
            _bookmarkImageView.transform = kMinimumScaleTransform;
            _bookmarkedNumberLabel.alpha = 0;
            _bookmarkedNumberLabel.transform = kMinimumScaleTransform;
        };
        void (^animationBlock)() = animationBlock = ^() {
            _bookmarkImageView.alpha = 1;
            _bookmarkImageView.transform = CGAffineTransformIdentity;
            _bookmarkedNumberLabel.alpha = 1;
            _bookmarkedNumberLabel.transform = CGAffineTransformIdentity;
            _numberLabel.alpha = 0;
        };

        if (animated) {
            setupBlock();
            [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:50 options:0 animations:animationBlock completion:nil];
        } else {
            animationBlock();
        }
    } else {
        _bookmarkImageView.hidden = YES;
        _bookmarkedNumberLabel.hidden = YES;
        _numberLabel.alpha = 1;
    }
}


#pragma mark -

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [super setForegroundColor:foregroundColor];

    for (VMScoreElementView* view in _elementViews)
        view.foregroundColor = foregroundColor;

    self.numberLabel.textColor = self.foregroundColor;

    [self setNeedsDisplay];
}

- (void)setBookmarkedColor:(UIColor *)bookmarkedColor {
    _bookmarkedColor = bookmarkedColor;
    _bookmarkImageView.image = [VMImageStore maskFillImage:[UIImage imageNamed:@"bg-bookmark"] withColor:bookmarkedColor];
}

- (const mxml::MeasureGeometry*)measureGeometry {
    return static_cast<const mxml::MeasureGeometry*>(self.geometry);
}

- (void)setMeasureGeometry:(const mxml::MeasureGeometry *)measureGeometry {
    [self setGeometry:measureGeometry];
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    
    if (geometry) {
        const Measure& measure = self.measureGeometry->measure();
        _numberLabel.text = [NSString stringWithUTF8String:measure.number().c_str()];
        _bookmarkedNumberLabel.text = _numberLabel.text;
    }
    
    [self clearElementViews];
    if (geometry)
        [self createElementViews];
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)clearElementViews {
    for (VMScoreElementView* view in _elementViews) {
        view.geometry = nullptr;
        view.hidden = YES;
        NSMutableArray* array = _reusableElementViews[view.class];
        if (!array) {
            array = [NSMutableArray array];
            _reusableElementViews[view.class] = array;
        }
        [array addObject:view];
    }
    [_elementViews removeAllObjects];
}

- (void)createElementViews {
    for (auto& geom : self.measureGeometry->geometries()) {
        if (const ClefGeometry* clef = dynamic_cast<const ClefGeometry*>(geom.get())) {
            VMClefView* view = [self reusableViewOfClass:[VMClefView class]];
            [self configureView:view];
            view.geometry = clef;
            [_elementViews addObject:view];
        } else if (const TimeSignatureGeometry* time = dynamic_cast<const TimeSignatureGeometry*>(geom.get())) {
            VMTimeSignatureView* view = [self reusableViewOfClass:[VMTimeSignatureView class]];
            [self configureView:view];
            view.geometry = time;
            [_elementViews addObject:view];
        } else if (const KeyGeometry* key = dynamic_cast<const KeyGeometry*>(geom.get())) {
            VMKeyView* view = [self reusableViewOfClass:[VMKeyView class]];
            [self configureView:view];
            view.geometry = key;
            [_elementViews addObject:view];
        } else if (const BarlineGeometry* barline = dynamic_cast<const BarlineGeometry*>(geom.get())) {
            VMBarlineView* view = [self reusableViewOfClass:[VMBarlineView class]];
            [self configureView:view];
            view.geometry = barline;
            [_elementViews addObject:view];
        } else if (const ChordGeometry* chord = dynamic_cast<const ChordGeometry*>(geom.get())) {
            VMChordView* view = [self reusableViewOfClass:[VMChordView class]];
            [self configureView:view];
            view.geometry = chord;
            [_elementViews addObject:view];
        } else if (const BeamGeometry* beam = dynamic_cast<const BeamGeometry*>(geom.get())) {
            VMBeamView* view = [self reusableViewOfClass:[VMBeamView class]];
            [self configureView:view];
            view.geometry = beam;
            [_elementViews addObject:view];
        } else if (const RestGeometry* rest = dynamic_cast<const RestGeometry*>(geom.get())) {
            VMRestView* view = [self reusableViewOfClass:[VMRestView class]];
            [self configureView:view];
            view.geometry = rest;
            [_elementViews addObject:view];
        }
    }
}

- (id)reusableViewOfClass:(Class)c {
    NSMutableArray* array = _reusableElementViews[c];
    if (array.count > 0) {
        VMScoreElementView* view = [array lastObject];
        [array removeLastObject];
        return view;
    }
    
    VMScoreElementView* view = [[c alloc] init];
    [self addSubview:view];
    return view;
}

- (void)configureView:(VMScoreElementView*)view {
    view.foregroundColor = self.foregroundColor;
    view.backgroundColor = self.backgroundColor;
    view.hidden = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _bookmarkImageView.center = CGPointMake(0, 0);

    _bookmarkedNumberLabel.center = CGPointMake(0, -2);
    _bookmarkedNumberLabel.bounds = {CGPointZero, _bookmarkImageView.bounds.size};

    _numberLabel.center = CGPointMake(0, 0);
    _numberLabel.bounds = {CGPointZero, [_numberLabel sizeThatFits:CGSizeZero]};
}

- (void)drawRect:(CGRect)rect {
    [self.foregroundColor setFill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    const Measure& measure = self.measureGeometry->measure();
    const Part* part = dynamic_cast<const Part*>(measure.parent());
    assert(part);
    
    int staves = part->staves();
    if (staves == 0)
        return;
    
    CGFloat staffDistance = part->staffDistance();
    
    CGSize size = self.bounds.size;
    CGFloat stavesHeight = self.measureGeometry->partGeometry().stavesHeight();
    CGRect lineRect;
    
    // Draw bar line
    lineRect.origin = CGPointZero;
    lineRect.origin.x -= kBarLineWidth/2;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = kBarLineWidth;
    lineRect.size.height = stavesHeight + kStaffLineWidth;
    CGContextFillRect(ctx, VMRoundRect(lineRect));
    
    // Draw staves
    lineRect.origin = CGPointZero;
    lineRect.origin.y -= kStaffLineWidth/2;
    lineRect.size.width = size.width;
    lineRect.size.height = kStaffLineWidth;
    for (int staff = 1; staff <= staves; staff += 1) {
        for (NSUInteger line = 0; line < PartGeometry::kStaffLineCount; line += 1) {
            CGContextFillRect(ctx, VMRoundRect(lineRect));
            lineRect.origin.y += PartGeometry::kStaffLineSpacing;
        }
        lineRect.origin.y += -PartGeometry::kStaffLineSpacing + staffDistance;
    }
    
    // Draw ledger lines
    for (auto& geom : self.geometry->geometries()) {
        if (auto chordGeom = dynamic_cast<ChordGeometry*>(geom.get())) {
            for (auto& noteGeom : chordGeom->notes()) {
                [self drawLedgerLinesForNoteGeom:noteGeom inStaffNumber:noteGeom->note().staff()];
            }
        }
    }
}

- (void)drawLedgerLinesForNoteGeom:(const NoteGeometry*)noteGeom inStaffNumber:(int)staff {
    const CGFloat staffOrigin = self.measureGeometry->partGeometry().staffOrigin(staff);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect lineRect;
    lineRect.origin = CGPointFromPoint(self.geometry->convertFromGeometry(noteGeom->origin(), noteGeom->parentGeometry()));
    lineRect.origin.x -= 2;
    lineRect.origin.y = staffOrigin - kStaffLineWidth/2;
    lineRect.size.width = noteGeom->size().width + 4;
    lineRect.size.height = kStaffLineWidth;
    
    CGFloat y = staffOrigin - PartGeometry::kStaffLineSpacing/2;
    while (noteGeom->location().y < y) {
        y -= PartGeometry::kStaffLineSpacing;
        lineRect.origin.y -= PartGeometry::kStaffLineSpacing;
        CGContextFillRect(ctx, VMRoundRect(lineRect));
    }
    
    lineRect.origin.y = (staffOrigin + PartGeometry::staffHeight()) - kStaffLineWidth/2;
    y = staffOrigin + PartGeometry::staffHeight() + PartGeometry::kStaffLineSpacing/2;
    while (noteGeom->location().y > y) {
        y += PartGeometry::kStaffLineSpacing;
        lineRect.origin.y += PartGeometry::kStaffLineSpacing;
        CGContextFillRect(ctx, VMRoundRect(lineRect));
    }
}

@end
