//  Created by Alejandro Isaza on 2014-04-09.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementImageView.h"
#include "RestGeometry.h"

@interface VMRestView : VMScoreElementImageView

+ (NSString*)headImageNameForType:(mxml::dom::Note::Type)type;

- (id)initWithRestGeometry:(const mxml::RestGeometry*)restGeom;

@property(nonatomic) const mxml::RestGeometry*restGeometry;

@end
