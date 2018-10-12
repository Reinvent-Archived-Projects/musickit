// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKSystemView.h"
#import "VMKSystemLayer.h"


@interface VMKSystemView ()

@property(nonatomic, strong, readonly) VMKSystemLayer* systemLayer;

@end


@implementation VMKSystemView

+ (Class)layerClass {
    return [VMKSystemLayer class];
}

- (VMKSystemLayer*)systemLayer {
    return (VMKSystemLayer*)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (instancetype)initWithSystemGeometry:(const mxml::SystemGeometry*)systemGeometry {
    self = [super initWithGeometry:systemGeometry];
    if (!self)
        return nil;

    self.systemLayer.systemGeometry = systemGeometry;
    return self;
}

- (const mxml::SystemGeometry*)systemGeometry {
    return static_cast<const mxml::SystemGeometry*>(self.systemLayer.systemGeometry);
}

- (void)setSystemGeometry:(const mxml::SystemGeometry *)systemGeometry {
    self.systemLayer.systemGeometry = systemGeometry;
}

- (void)setNoteColors:(NSArray *)noteColors {
    self.systemLayer.noteColors = noteColors;
}

@end
