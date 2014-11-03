//  Created by Alejandro Isaza on 2014-05-14.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include "dom/Credit.h"

@interface VMCreditsView : UIView

@property(nonatomic) std::vector<mxml::dom::Credit> credits;
@property(nonatomic, strong) UIColor* foregroundColor;

@end
