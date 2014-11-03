//  Created by Alejandro Isaza on 2014-04-01.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMAdHocScoreTestCase.h"
#import "VMClefView.h"

#include "Score.h"

using namespace mxml::dom;

@interface VMClefViewTests : VMAdHocScoreTestCase

@end

@implementation VMClefViewTests

- (void)testTreble {
    Clef clef = Clef::trebleClef();
    mxml::ClefGeometry geom(clef);
    VMClefView* view = [[VMClefView alloc] initWithClefGeometry:&geom];
    
    CGSize size = [view sizeThatFits:CGSizeZero];
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testView:view forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
