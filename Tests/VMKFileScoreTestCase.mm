// Copyright © 2016 Venture Media Labs.
//
// This file is part of MusicKit. The full MusicKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#import "VMKFileScoreTestCase.h"

#include <mxml/parsing/ScoreHandler.h>

#include "lxml.h"
#include <fstream>

@implementation VMKFileScoreTestCase

- (std::unique_ptr<mxml::dom::Score>)loadScore:(NSString*)name {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:name ofType:@"xml"];

    mxml::parsing::ScoreHandler handler;
    std::ifstream is([path UTF8String]);
    lxml::parse(is, [path UTF8String], handler);
    return handler.result();
}

@end
