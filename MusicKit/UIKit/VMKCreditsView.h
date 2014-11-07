//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/dom/Credit.h>


@interface VMKCreditsView : UIView

@property(nonatomic) std::vector<mxml::dom::Credit> credits;
@property(nonatomic, strong) UIColor* foregroundColor;

@end
