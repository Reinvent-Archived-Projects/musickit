//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

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
