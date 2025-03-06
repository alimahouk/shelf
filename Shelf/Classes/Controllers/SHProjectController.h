//
//  SHProjectController.h
//  Shelf
//
//  Created by Ali Mahouk on 4/6/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHProjectController : NSObject {
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong) NSMutableArray *projectsArray;

- (NSManagedObject *)objectWithURI:(NSURL *)URI;
- (NSManagedObjectID *)createNewProject;
- (void)deleteObjectWithID:(NSString *)objectID;
- (id)getProperty:(NSString *)propertyName forObjectID:(NSString *)objectID;
- (void)setProperty:(id)property forPropertyName:(NSString *)propertyName forObjectID:(NSString *)objectID;

@end
