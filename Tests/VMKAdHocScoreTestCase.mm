// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKAdHocScoreTestCase.h"

#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
#include <mxml/SpanFactory.h>


@implementation VMKAdHocScoreTestCase {
    std::unique_ptr<mxml::ScoreBuilder> _builder;
}

- (void)setUp {
    [super setUp];

    _builder.reset(new mxml::ScoreBuilder{});

    _part = _builder->addPart();
    _measure = _builder->addMeasure(_part);
    _attributes = _builder->addAttributes(_measure);
    _attributes->setStaves(mxml::dom::presentOptional(1));
    _builder->setTrebleClef(_attributes);
    _builder->setKey(_attributes);
}

- (void)tearDown {
    _builder.reset();
}

- (mxml::ScoreBuilder*)builder {
    return _builder.get();
}

@end
