//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"

#import "VMKMeasureView.h"
#import "VMKScrollScoreDataSource.h"
#import "VMKScrollScoreLayout.h"
#import "VMKTieView.h"

#include "lxml.h"
#include "ScrollScoreGeometry.h"
#include "ScoreHandler.h"
#include "SpanFactory.h"

#include <fstream>

@interface VMKScrollScoreLayoutTests : VMKLayerTestCase
@property(nonatomic, strong) VMKScrollScoreLayout* scoreLayout;
@property(nonatomic, strong) VMKScrollScoreDataSource* dataSource;
@property(nonatomic, strong) UICollectionView* collectionView;
@end

@implementation VMKScrollScoreLayoutTests {
    std::unique_ptr<mxml::dom::Score> _score;
    std::unique_ptr<mxml::ScrollScoreGeometry> _geometry;
}

- (void)setUp {
    [super setUp];

    self.scoreLayout = [[VMKScrollScoreLayout alloc] init];
    self.dataSource = [[VMKScrollScoreDataSource alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) collectionViewLayout:self.scoreLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VMKMeasureReuseIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VMKTieReuseIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VMKDirectionReuseIdentifier];
    self.collectionView.dataSource = self.dataSource;
}

- (void)tearDown {
    [super tearDown];

    _geometry.reset();
    _score.reset();
}

- (void)load:(NSString*)path {
    mxml::ScoreHandler handler;
    std::ifstream is([path UTF8String]);
    lxml::parse(is, [path UTF8String], handler);
    _score = handler.result();
    
    if (!_score->parts().empty() && !_score->parts().front()->measures().empty()) {
        _geometry.reset(new mxml::ScrollScoreGeometry(*_score));
    } else {
        _geometry.reset();
    }
    
    self.scoreLayout.minHeight = self.collectionView.bounds.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;
    self.scoreLayout.scoreGeometry = _geometry.get();
    self.dataSource.scoreGeometry = _geometry.get();
    [self.collectionView reloadData];
}

- (void)testSlurs {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"Slurs" ofType:@"xml"];
    [self load:path];

    [self testLayer:self.collectionView.layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testEndings {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"Endings" ofType:@"xml"];
    [self load:path];

    [self testLayer:self.collectionView.layer forSelector:_cmd withAccuracy:0.0001];
}

- (void)testAccidentals {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"Accidentals" ofType:@"xml"];
    [self load:path];
    
    [self testLayer:self.collectionView.layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

- (void)testAccidentals2 {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"Accidentals2" ofType:@"xml"];
    [self load:path];
    
    [self testLayer:self.collectionView.layer forSelector:_cmd withAccuracy:VIEW_RENDER_ACCURACY];
}

@end
