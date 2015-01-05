//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKMeasureLayer.h"

#include "Print.h"
#include "PartGeometry.h"
#include "SpanFactory.h"

using namespace mxml::dom;

@interface VMKMeasureLayerTests : VMKAdHocScoreTestCase

@end

@implementation VMKMeasureLayerTests {
    Attributes* _attributes;
}

- (void)setUp {
    [super setUp];
    
    Measure* measure = self.measure;
    
    
    std::unique_ptr<Attributes> attributes(new Attributes{});
    attributes->setStaves(presentOptional(2));
    _attributes = attributes.get();
    
    measure->addNode(std::move(attributes));
    
    auto staffLayout = std::unique_ptr<StaffLayout>(new StaffLayout{});
    staffLayout->setStaffDistance(65);
    
    std::unique_ptr<Print> print(new Print);
    print->setStaffLayout(std::move(staffLayout));
    
    measure->addNode(std::move(print));
}

- (void)testEmpty {
    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];
    
    CGSize size = layer.preferredFrameSize;
    XCTAssertTrue(size.width > 0, @"Width should be greater than zero");
    XCTAssertTrue(size.height > 0, @"Height should be greater than zero");

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWithClefs {
    Measure* measure = self.measure;
    
    std::unique_ptr<Attributes> attributes(new Attributes);
    attributes->setStaves(2);
    
    auto clef = std::unique_ptr<Clef>(new Clef{});
    clef->setNumber(1);
    clef->setSign(Clef::SIGN_G);
    clef->setLine(2);
    attributes->setClef(1, std::move(clef));
    
    clef.reset(new Clef{});
    clef->setNumber(2);
    clef->setSign(Clef::SIGN_F);
    clef->setLine(4);
    attributes->setClef(2, std::move(clef));
    
    measure->addNode(std::move(attributes));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWithTimeSignatures {
    Measure* measure = self.measure;
    
    std::unique_ptr<Attributes> attributes(new Attributes);
    attributes->setStaves(2);
    
    auto time = std::unique_ptr<Time>(new Time{});
    time->setNumber(1);
    time->setBeats(3);
    time->setBeatType(4);
    attributes->setTime(std::move(time));
    
    measure->addNode(std::move(attributes));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testWithClefsAndTimeSignatures {
    Measure* measure = self.measure;
    
    std::unique_ptr<Attributes> attributes(new Attributes);
    attributes->setStaves(2);
    
    auto clef = std::unique_ptr<Clef>(new Clef{});
    clef->setNumber(1);
    clef->setSign(Clef::SIGN_G);
    clef->setLine(2);
    attributes->setClef(1, std::move(clef));
    
    clef.reset(new Clef{});
    clef->setNumber(2);
    clef->setSign(Clef::SIGN_F);
    clef->setLine(4);
    attributes->setClef(2, std::move(clef));
    
    auto time = std::unique_ptr<Time>(new Time{});
    time->setNumber(1);
    time->setBeats(3);
    time->setBeatType(4);
    attributes->setTime(std::move(time));
    
    measure->addNode(std::move(attributes));

    mxml::MeasureGeometry* geom = [self measureGeometry];
    VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithMeasure:geom];

    [self testLayer:layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
