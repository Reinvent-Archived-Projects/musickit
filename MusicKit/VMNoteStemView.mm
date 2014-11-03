//  Created by Alejandro Isaza on 2014-04-07.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMNoteStemView.h"

using namespace mxml::dom;

@implementation VMNoteStemView

+ (NSString*)stemImageNameForNote:(const mxml::dom::Note&)note {
    NSString* name;
    switch (note.type()) {
        case Note::TYPE_1024TH:
        case Note::TYPE_512TH:
        case Note::TYPE_256TH:
        case Note::TYPE_128TH:
            name = @"128th"; break;
            
        case Note::TYPE_64TH:
            name = @"64th"; break;
            
        case Note::TYPE_32ND:
            name = @"32nd"; break;
            
        case Note::TYPE_16TH:
            name = @"16th"; break;
            
        case Note::TYPE_EIGHTH:
            name = @"eighth"; break;
            
        case Note::TYPE_QUARTER:
        case Note::TYPE_HALF:
            name = @"quarter"; break;
            
        default:
            name = nil;
    }
    if (name == nil)
        return nil;
    
    NSString* dir = nil;
    if (note.stem() == STEM_UP || note.stem() == STEM_DOUBLE)
        dir = @"up";
    else if (note.stem() == STEM_DOWN)
        dir = @"down";
    if (dir == nil)
        return nil;
    
   return [NSString stringWithFormat:@"%@-%@", name, dir];
}

+ (NSString*)noFlagsStemImageNameForNote:(const mxml::dom::Note&)note {
    NSString* name = @"quarter";
    
    NSString* dir = nil;
    if (note.stem() == STEM_UP || note.stem() == STEM_DOUBLE)
        dir = @"up";
    else if (note.stem() == STEM_DOWN)
        dir = @"down";
    if (dir == nil)
        return nil;
    
    return [NSString stringWithFormat:@"%@-%@", name, dir];
}

- (id)initWithStemGeometry:(const mxml::StemGeometry*)stemGeom {
    return [super initWithGeometry:stemGeom];
}

- (const mxml::StemGeometry*)stemGeometry {
    return static_cast<const mxml::StemGeometry*>(self.geometry);
}

- (void)setGeometry:(const mxml::Geometry *)geometry {
    [super setGeometry:geometry];
    [self updateImage];
}

- (void)updateImage {
    if (self.geometry) {
        const Note& note = self.stemGeometry->note();
        if (self.stemGeometry->showFlags())
            self.imageName = [[self class] stemImageNameForNote:note];
        else
            self.imageName = [[self class] noFlagsStemImageNameForNote:note];
    } else {
        self.imageName = nil;
    }
    
    [self sizeToFit];
    [self invalidateIntrinsicContentSize];
}

@end
