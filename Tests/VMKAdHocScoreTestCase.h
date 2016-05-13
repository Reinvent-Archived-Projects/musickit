// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKLayerTestCase.h"

#include <mxml/ScoreBuilder.h>
#include <mxml/dom/Part.h>


@interface VMKAdHocScoreTestCase : VMKLayerTestCase

@property(nonatomic, readonly) mxml::ScoreBuilder* builder;
@property(nonatomic) mxml::dom::Part* part;
@property(nonatomic) mxml::dom::Measure* measure;
@property(nonatomic) mxml::dom::Attributes* attributes;

@end
