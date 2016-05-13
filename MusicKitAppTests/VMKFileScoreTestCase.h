// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKLayerTestCase.h"

#include <mxml/dom/Score.h>

@interface VMKFileScoreTestCase : VMKLayerTestCase

- (std::unique_ptr<mxml::dom::Score>)loadScore:(NSString*)name;

@end
