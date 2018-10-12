// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKGeometry.h"
#import "VMKMeasureLayer.h"
#import "VMKPartLayer.h"
#import "VMKSystemLayer.h"


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

- (void)setActiveForegroundColor:(VMKColor*)foregroundColor {
    [super setActiveForegroundColor:foregroundColor];

    for (VMKPartLayer* layer in self.partLayers)
        layer.activeForegroundColor = foregroundColor;
}

- (void)setInactiveForegroundColor:(VMKColor*)foregroundColor {
    [super setInactiveForegroundColor:foregroundColor];

    for (VMKPartLayer* layer in self.partLayers)
        layer.inactiveForegroundColor = foregroundColor;
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
    [self setNeedsDisplay];
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
            layer = [[VMKPartLayer alloc] initWithPartGeometry:geometry noteColors:self.noteColors];
            [self addSublayer:layer];
        }

        layer.activeForegroundColor = self.activeForegroundColor;
        layer.inactiveForegroundColor = self.inactiveForegroundColor;
        layer.backgroundColor = self.backgroundColor;
        layer.hidden = NO;

        [self.partLayers addObject:layer];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetFillColorWithColor(ctx, self.foregroundColor.CGColor);

    CGSize size = self.bounds.size;
    auto systemGeometry = self.systemGeometry;
    for (std::size_t partIndex = 0; partIndex < systemGeometry->partGeometries().size(); partIndex += 1) {
        auto& partGeometry = systemGeometry->partGeometries().at(partIndex);
        auto& measureGeometry = partGeometry->measureGeometries().at(0);

        CGFloat stavesHeight = partGeometry->stavesHeight();
        auto origin = measureGeometry->convertToGeometry({0, 0}, systemGeometry);
        CGRect lineRect;

        // Draw bar lines
        lineRect.origin.x = 0;
        lineRect.origin.y = origin.y - VMKStaffLineWidth/2;
        lineRect.size.width = VMKBarLineWidth;
        lineRect.size.height = stavesHeight + VMKStaffLineWidth;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));

        lineRect.origin.x = size.width - VMKBarLineWidth;
        lineRect.origin.y = origin.y - VMKStaffLineWidth/2;
        lineRect.size.width = VMKBarLineWidth;
        lineRect.size.height = stavesHeight + VMKStaffLineWidth;
        CGContextFillRect(ctx, VMKRoundRect(lineRect));
    }
}

@end
