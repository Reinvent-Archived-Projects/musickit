//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKSystemLayer.h"
#import "VMKPartLayer.h"


@interface VMKSystemLayer ()

@property(nonatomic, strong) NSMutableArray* partLayers;
@property(nonatomic, strong) NSMutableSet* reusablePartLayers;

@end


@implementation VMKSystemLayer

- (instancetype)initWithSystemGeometry:(const mxml::SystemGeometry*)systemGeometry {
    return [super initWithGeometry:systemGeometry];
}

- (void)setup {
    [super setup];
    self.partLayers = [[NSMutableArray alloc] init];
    self.reusablePartLayers = [[NSMutableSet alloc] init];
}


#pragma mark -

- (void)setForegroundColor:(CGColorRef)foregroundColor {
    [super setForegroundColor:foregroundColor];

    for (VMKPartLayer* layer in self.partLayers)
        layer.foregroundColor = foregroundColor;
}

- (const mxml::SystemGeometry*)systemGeometry {
    return static_cast<const mxml::SystemGeometry*>(self.geometry);
}

- (void)setSystemGeometry:(const mxml::SystemGeometry*)systemGeometry {
    self.geometry = systemGeometry;
}

- (void)setGeometry:(const mxml::Geometry*)geometry {
    [super setGeometry:geometry];

    [self clearSublayers];
    if (geometry)
        [self createSublayers];
    [self setNeedsLayout];
}

- (void)clearSublayers {
    for (VMKPartLayer* layer in self.partLayers) {
        layer.geometry = nullptr;
        layer.hidden = YES;
        [self.reusablePartLayers addObject:layer];
    }
    [self.partLayers removeAllObjects];
}

- (void)createSublayers {
    auto& partGeometries = self.systemGeometry->partGeometries();
    for (auto& geometry : partGeometries) {
        VMKPartLayer* layer;
        if (self.reusablePartLayers.count > 0) {
            layer = [self.reusablePartLayers anyObject];
            [self.reusablePartLayers removeObject:layer];
            layer.partGeometry = geometry;
        } else {
            layer = [[VMKPartLayer alloc] initWithPartGeometry:geometry];
            [self addSublayer:layer];
        }

        layer.foregroundColor = self.foregroundColor;
        layer.backgroundColor = self.backgroundColor;
        layer.hidden = NO;

        [self.partLayers addObject:layer];
    }
}

@end
