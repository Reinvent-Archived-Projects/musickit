//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKPartLayer.h"
#import "VMKMeasureLayer.h"


@interface VMKPartLayer ()

@property(nonatomic, strong) NSMutableArray* measureLayers;
@property(nonatomic, strong) NSMutableSet* reusableMeasureLayers;

@end


@implementation VMKPartLayer

- (instancetype)initWithPartGeometry:(const mxml::PartGeometry*)partGeometry {
    return [super initWithGeometry:partGeometry];
}

- (void)setup {
    [super setup];
    self.measureLayers = [[NSMutableArray alloc] init];
    self.reusableMeasureLayers = [[NSMutableSet alloc] init];
}

#pragma mark - 

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    [super setForegroundColor:foregroundColor];

    for (VMKMeasureLayer* layer in self.measureLayers)
        layer.foregroundColor = foregroundColor;
}

- (const mxml::PartGeometry*)partGeometry {
    return static_cast<const mxml::PartGeometry*>(self.geometry);
}

- (void)setPartGeometry:(const mxml::PartGeometry*)partGeometry {
    self.geometry = partGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];

    [self clearSublayers];
    if (geometry)
        [self createSublayers];
    [self setNeedsLayout];
}

- (void)clearSublayers {
    for (VMKMeasureLayer* layer in self.measureLayers) {
        layer.geometry = nullptr;
        layer.hidden = YES;
        [self.reusableMeasureLayers addObject:layer];
    }
    [self.measureLayers removeAllObjects];
}

- (void)createSublayers {
    auto& measureGeometries = self.partGeometry->measureGeometries();
    for (auto& geometry : measureGeometries) {
        VMKMeasureLayer* layer;
        if (self.reusableMeasureLayers.count > 0) {
            layer = [self.reusableMeasureLayers anyObject];
            [self.reusableMeasureLayers removeObject:layer];
            layer.measureGeometry = geometry;
        } else {
            layer = [[VMKMeasureLayer alloc] initWithMeasure:geometry];
            [self addSublayer:layer];
        }

        layer.foregroundColor = self.foregroundColor;
        layer.backgroundColor = self.backgroundColor;
        layer.hidden = NO;

        [self.measureLayers addObject:layer];
    }
}

@end
