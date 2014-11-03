//  Created by Alejandro Isaza on 2014-03-27.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMAdHocScoreTestCase.h"
#import "VMImageStore.h"
#import "VMTimeSignatureView.h"


@interface VMTimeSignatureViewTests : VMAdHocScoreTestCase

@end

@implementation VMTimeSignatureViewTests

- (void)testCommonTime {
    mxml::dom::Time time;
    time.setSymbol(mxml::dom::Time::SYMBOL_COMMON);
    
    mxml::TimeSignatureGeometry geom(time);
    
    VMTimeSignatureView* view = [[VMTimeSignatureView alloc] init];
    view.geometry = &geom;
    
    CGSize size = [view sizeThatFits:CGSizeZero];
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testView:view forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testVerticalDigits {
    mxml::dom::Time time;
    time.setBeats(3);
    time.setBeatType(16);
    
    mxml::TimeSignatureGeometry geom(time);
    
    VMTimeSignatureView* view = [[VMTimeSignatureView alloc] init];
    view.geometry = &geom;
    
    CGSize size = [view sizeThatFits:CGSizeZero];
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testView:view forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
