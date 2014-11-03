//  Created by Alejandro Isaza on 2014-04-07.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMScoreElementImageView.h"
#include "StemGeometry.h"

@interface VMNoteStemView : VMScoreElementImageView

/**
 Get the image name for the note's stem.
 */
+ (NSString*)stemImageNameForNote:(const mxml::dom::Note&)note;

- (id)initWithStemGeometry:(const mxml::StemGeometry*)stemGeom;

- (const mxml::StemGeometry*)stemGeometry;

@end
