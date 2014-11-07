//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKScoreElementContainerView.h"
#import "VMKOrnamentLayer.h"


@interface VMKOrnamentView : VMKScoreElementContainerView

- (instancetype)initWithOrnamentsGeometry:(const mxml::OrnamentsGeometry*)ornamentsGeometry;

@property(nonatomic) const mxml::OrnamentsGeometry* ornamentsGeometry;
@property(nonatomic, readonly) VMKOrnamentLayer* ornamentLayer;

@end
