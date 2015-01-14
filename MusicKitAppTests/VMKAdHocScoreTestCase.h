//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"

#include <mxml/ScoreBuilder.h>
#include <mxml/dom/Part.h>


@interface VMKAdHocScoreTestCase : VMKLayerTestCase

@property(nonatomic, readonly) mxml::ScoreBuilder* builder;
@property(nonatomic) mxml::dom::Part* part;
@property(nonatomic) mxml::dom::Measure* measure;
@property(nonatomic) mxml::dom::Attributes* attributes;

@end
