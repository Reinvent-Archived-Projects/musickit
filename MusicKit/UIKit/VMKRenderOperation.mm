//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKRenderOperation.h"
#import "VMKSystemLayer.h"


@implementation VMKRenderOperation

+ (instancetype)operationForSystemGeometry:(const mxml::SystemGeometry*)systemGeometry {
    VMKRenderOperation* op = [[self.class alloc] init];
    op.systemGeometry = systemGeometry;
    return op;
}

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;

    self.backgroundColor = [VMKColor clearColor];
    self.activeForegroundColor = [VMKColor blackColor];
    self.inactiveForegroundColor = [VMKColor lightGrayColor];

    return self;
}

- (void)main {
    @autoreleasepool {
        VMKSystemLayer* systemLayer = [[VMKSystemLayer alloc] initWithSystemGeometry:self.systemGeometry];
        systemLayer.activeForegroundColor = self.activeForegroundColor;
        systemLayer.inactiveForegroundColor = self.inactiveForegroundColor;
        systemLayer.backgroundColor = self.backgroundColor.CGColor;
        [systemLayer layoutIfNeeded];

        self.image = VMKRenderImage(systemLayer.bounds.size, ^(CGContextRef ctx) {
            CGContextTranslateCTM(ctx, -systemLayer.bounds.origin.x, -systemLayer.bounds.origin.y);
            [systemLayer renderInContext:ctx];
        });
        if (self.cancelled)
            self.image = nil;
    }
}

@end
