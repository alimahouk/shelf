//
//  Project.h
//  Shelf
//
//  Created by Ali Mahouk on 3/23/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property (strong) NSString *deviceColor;
@property (strong) NSString *projectID;
@property (strong) NSString *projectName;
@property (strong) NSDate *projectDateAdded;
@property (strong) NSDate *projectDateModified;
@property (strong) NSData *projectIcon;
@property (strong) NSString *projectType;
@property (strong) NSString *projectCollectionID;
@property (strong) NSString *rootDirPath;
@property (strong) NSString *projectFilePath;
@property (strong) NSString *projectThumbnailImagePath_1;

@end
