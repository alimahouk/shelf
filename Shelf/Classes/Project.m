//
//  Project.m
//  Shelf
//
//  Created by Ali Mahouk on 3/23/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "Project.h"

@implementation Project

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        _deviceColor = @"";
        _projectID = @"";
        _projectName = @"";
        _projectDateAdded = [NSDate date];
        _projectDateModified = [NSDate date];
        _projectType = @"";
        _projectCollectionID = @"";
        _rootDirPath = @"";
        _projectFilePath = @"";
        _projectThumbnailImagePath_1 = @"";
    }
    
    return self;
}

@end
