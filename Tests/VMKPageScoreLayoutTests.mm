// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKLayerTestCase.h"

#import "VMKClefLayer.h"
#import "VMKKeyLayer.h"
#import "VMKPageScoreLayout.h"
#import "VMKPageScoreDataSource.h"
#import "VMKTimeSignatureLayer.h"

#include "ScoreHandler.h"
#include "lxml.h"
#include <fstream>

@interface VMKPageScoreLayoutTests : VMKLayerTestCase
@property(nonatomic, strong) VMKPageScoreLayout* scoreLayout;
@property(nonatomic, strong) VMKPageScoreDataSource* dataSource;
@property(nonatomic, strong) UICollectionView* collectionView;
@end

@implementation VMKPageScoreLayoutTests {
    std::unique_ptr<mxml::dom::Score> _score;
    std::unique_ptr<mxml::PageScoreGeometry> _geometry;
}

- (void)setUp {
    [super setUp];
    
    self.scoreLayout = [[VMKPageScoreLayout alloc] init];
    self.dataSource = [[VMKPageScoreDataSource alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) collectionViewLayout:self.scoreLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VMKSystemReuseIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VMKSystemCursorReuseIdentifier];
    self.collectionView.dataSource = self.dataSource;
}

- (void)tearDown {
    [super tearDown];
    
    _geometry.reset();
    _score.reset();
}

- (void)load:(NSString*)path {
    mxml::parsing::ScoreHandler handler;
    std::ifstream is([path UTF8String]);
    lxml::parse(is, [path UTF8String], handler);
    _score = handler.result();
    
    if (!_score->parts().empty() && !_score->parts().front()->measures().empty()) {
        _geometry.reset(new mxml::PageScoreGeometry(*_score, 728));
    } else {
        _geometry.reset();
    }
    
    self.scoreLayout.scoreGeometry = _geometry.get();
    self.dataSource.scoreGeometry = _geometry.get();
    self.collectionView.frame = CGRectMake(0, 0, _geometry->frame().size.width, _geometry->frame().size.height);
    [self.collectionView reloadData];
}

- (void)testAttributes {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"system_attributes" ofType:@"xml"];
    [self load:path];

    [self overrideLayerBackgorunds:self.collectionView.layer dictionary:@{VMKClefLayer.class: [UIColor blueColor],
                                                                          VMKKeyLayer.class: [UIColor redColor],
                                                                          VMKTimeSignatureLayer.class: [UIColor greenColor]}];

    [self calculateRenderingErrors:self.collectionView.layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testAttributesFail {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"system_attributes" ofType:@"xml"];
    [self load:path];

    [self overrideLayerBackgorunds:self.collectionView.layer dictionary:@{VMKClefLayer.class: [UIColor blueColor],
                                                                          VMKKeyLayer.class: [UIColor redColor],
                                                                          VMKTimeSignatureLayer.class: [UIColor greenColor]}];

    [self calculateRenderingErrors:self.collectionView.layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertGreaterThan(errors.maximumError, kMaximumError);
    }];
}

- (void)testSlurs {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"slurs" ofType:@"xml"];
    [self load:path];

    [self calculateRenderingErrors:self.collectionView.layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
