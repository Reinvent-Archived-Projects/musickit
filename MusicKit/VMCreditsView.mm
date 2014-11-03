//  Created by Alejandro Isaza on 2014-05-14.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMCreditsView.h"

using mxml::dom::Credit;
using mxml::dom::CreditWords;

static const CGFloat kLabelSpacing = 8;
static const CGFloat kRowSpacing = 8;


@implementation VMCreditsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder {
    self = [super initWithCoder:decoder];
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return self;
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    for (UIView* rowView in self.subviews) {
        for (UILabel* label in rowView.subviews) {
            label.textColor = self.foregroundColor;
        }
    }
}

- (void)setCredits:(std::vector<mxml::dom::Credit>)credits {
    _credits = credits;
    
    for (UIView* view in self.subviews)
        [view removeFromSuperview];
    
    NSMutableArray* rows = [NSMutableArray arrayWithCapacity:_credits.size()];
    
    NSLayoutConstraint* constraint;
    UIView* first = nil;
    UIView* last = nil;
    
    for (const Credit& credit : _credits) {
        UIView* rowView = [self rowViewFromCredit:credit];
        [rows addObject:rowView];
        
        // Horizontal constraints
        constraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                     toItem:self attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                     toItem:self attribute:NSLayoutAttributeRight
                                                 multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeCenterX
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self attribute:NSLayoutAttributeCenterX
                                                 multiplier:1.0 constant:0.0];
        [self addConstraint:constraint];
        
        if (last) {
            // Vertical constraint
            constraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:last attribute:NSLayoutAttributeBottom
                                                     multiplier:1.0 constant:kRowSpacing];
            [self addConstraint:constraint];
            
            // Size constraint
            constraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:last attribute:NSLayoutAttributeWidth
                                                     multiplier:1.0 constant:0];
            [self addConstraint:constraint];
        }
        
        if (!first)
            first = rowView;
        last = rowView;
    }
    
    // Edges constraints
    if (first) {
        constraint = [NSLayoutConstraint constraintWithItem:first attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                     toItem:self attribute:NSLayoutAttributeTop
                                                 multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:last attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                     toItem:self attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0 constant:0];
        constraint.priority = UILayoutPriorityDefaultHigh;
        [self addConstraint:constraint];
    }
    
    [self layoutIfNeeded];
}

- (UIView*)rowViewFromCredit:(const Credit&)credit {
    UIView* rowView = [[UIView alloc] init];
    rowView.backgroundColor = [UIColor clearColor];
    rowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:rowView];
    
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:credit.creditWords().size()];
    UILabel* first = nil;
    UILabel* last = nil;
    NSLayoutConstraint* constraint;
    
    for (const CreditWords& words : credit.creditWords()) {
        UILabel* label = [self labelFromCreditWords:words];
        [labels addObject:label];
        [rowView addSubview:label];
        
        // Vertical constraints
        constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                     toItem:rowView attribute:NSLayoutAttributeTop
                                                 multiplier:1.0 constant:0];
        [rowView addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                     toItem:rowView attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0 constant:0];
        [rowView addConstraint:constraint];
        
        // Horizontal constraint
        if (last) {
            constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:last attribute:NSLayoutAttributeRight
                                                     multiplier:1.0 constant:kLabelSpacing];
            [rowView addConstraint:constraint];
        }
        
        if (!first)
            first = label;
        last = label;
    }
    
    // Edges constraints
    if (first) {
        constraint = [NSLayoutConstraint constraintWithItem:first attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:rowView attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0 constant:0];
        [rowView addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:last attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:rowView attribute:NSLayoutAttributeRight
                                                 multiplier:1.0 constant:0];
        [rowView addConstraint:constraint];
    }
    constraint = [NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0 constant:400];
    [rowView addConstraint:constraint];
    
    [rowView layoutIfNeeded];
    return rowView;
}

- (UILabel*)labelFromCreditWords:(const CreditWords&)words {
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.foregroundColor;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (words.fontStyle() == CreditWords::FONT_STYLE_ITALIC && words.fontWeight() == CreditWords::FONT_WEIGHT_BOLD)
        label.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:words.fontSize()];
    else if (words.fontStyle() == CreditWords::FONT_STYLE_ITALIC)
        label.font = [UIFont fontWithName:@"Baskerville-Italic" size:words.fontSize()];
    else if (words.fontWeight() == CreditWords::FONT_WEIGHT_BOLD)
        label.font = [UIFont fontWithName:@"Baskerville-Bold" size:words.fontSize()];
    else
        label.font = [UIFont fontWithName:@"Baskerville" size:words.fontSize()];
    
    label.text = [NSString stringWithUTF8String:words.contents().c_str()];
    label.preferredMaxLayoutWidth = 600;
    return label;
}

@end
