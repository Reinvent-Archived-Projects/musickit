//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"

#include <mxml/dom/Score.h>

@interface VMKFileScoreTestCase : VMKLayerTestCase

- (std::unique_ptr<mxml::dom::Score>)loadScore:(NSString*)name;

@end
