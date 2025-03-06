//
//  SHProject.h
//  Shelf
//
//  Created by Ali Mahouk on 4/6/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SHProject : NSManagedObject

@property (nonatomic, retain) NSString *deviceColor;
@property (nonatomic, retain) NSString *projectID;
@property (nonatomic, retain) NSString *projectName;
@property (nonatomic, retain) NSDate *projectDateAdded;
@property (nonatomic, retain) NSDate *projectDateModified;
@property (nonatomic, retain) NSData *projectIcon;
@property (nonatomic, retain) NSString *projectType;
@property (nonatomic, retain) NSString *projectCollectionID;
@property (nonatomic, retain) NSString *rootDirPath;
@property (nonatomic, retain) NSString *projectFilePath;
@property (nonatomic, retain) NSString *projectThumbnailImagePath_1;

@end
