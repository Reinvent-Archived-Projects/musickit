//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

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
