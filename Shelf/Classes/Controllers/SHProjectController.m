//
//  SHProjectController.m
//  Shelf
//
//  Created by Ali Mahouk on 4/6/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "SHProjectController.h"
#import "AppDelegate.h"
#import "SHProject.h"

@implementation SHProjectController

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        if ( managedObjectContext == nil )
        {
            persistentStoreCoordinator = [(AppDelegate *)[[NSApplication sharedApplication] delegate] persistentStoreCoordinator];
            managedObjectContext = [(AppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
        }
        
        /*
         Fetch existing SHProject objects.
         Create a fetch request; find the SHProject entity and assign it to the request; then execute the fetch.
         */
        NSFetchRequest *request_project = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity_project = [NSEntityDescription entityForName:@"SHProject" inManagedObjectContext:managedObjectContext];
        [request_project setEntity:entity_project];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError *error_project = nil;
        NSMutableArray *mutableFetchResults_project = [[managedObjectContext executeFetchRequest:request_project error:&error_project] mutableCopy];
        
        if ( mutableFetchResults_project == nil ) // Handle the error.
        {
            NSLog(@"Empty fetch results.");
        }
        
        // Set self's projects array to the mutable array, then clean up.
        _projectsArray = mutableFetchResults_project;
        
        // Sort alphabetically.
        NSArray *sortedArray = [_projectsArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(SHProject *)a projectName];
            NSString *second = [(SHProject *)b projectName];
            return [first compare:second];
        }];
        
        _projectsArray = [sortedArray mutableCopy];
    }
    
    return self;
}

- (NSManagedObject *)objectWithURI:(NSURL *)URI
{
    NSManagedObjectID *objectID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:URI];
    
    if ( !objectID )
    {
        return nil;
    }
    
    NSManagedObject *objectForID = [managedObjectContext objectWithID:objectID];
    
    if ( ![objectForID isFault] )
    {
        return objectForID;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[objectID entity]];
    
    // Equivalent to
    // predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
    NSPredicate *predicate = [NSComparisonPredicate
     predicateWithLeftExpression:
     [NSExpression expressionForEvaluatedObject]
     rightExpression:
     [NSExpression expressionForConstantValue:objectForID]
     modifier:NSDirectPredicateModifier
     type:NSEqualToPredicateOperatorType
     options:0];
    [request setPredicate:predicate];
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    
    if ([results count] > 0 )
    {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

- (NSManagedObjectID *)createNewProject
{
    SHProject *project = (SHProject *)[NSEntityDescription insertNewObjectForEntityForName:@"SHProject" inManagedObjectContext:managedObjectContext];
    
    // Commit the change.
    NSError *error;
    NSError *error_PermanentIDs;
    [managedObjectContext obtainPermanentIDsForObjects:@[project] error:&error_PermanentIDs];
    
    if ( ![managedObjectContext save:&error] )
    {
        // Handle the error.
    }
    
    NSManagedObjectID *objectID = [project objectID];
    
    // Prepare the project to add it to the array.
    // ID is needed for searching later on.
    NSURL *objectURL = [objectID URIRepresentation];
    NSString *projectID = [objectURL absoluteString];
    project.projectID = projectID;
    [_projectsArray insertObject:project atIndex:0];
    
    return objectID;
}

- (void)deleteObjectWithID:(NSString *)objectID
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSURL *objectURL = [NSURL URLWithString:objectID];
    NSManagedObject *deadObject = [self objectWithURI:objectURL];
    SHProject *deadProject_local;
    SHProject *deadProject_arrayController;
    
    for ( SHProject *p in _projectsArray )
    {
        if ( [p.projectID isEqualToString:objectID] )
        {
            deadProject_local = p;
            
            for ( SHProject *p in appDelegate.appController.arrayController.arrangedObjects )
            {
                if ( [p.projectID isEqualToString:objectID] )
                {
                    deadProject_arrayController = p;
                }
            }
        }
    }
    
    // Take out the trash.
    [_projectsArray removeObject:deadProject_local];
    [appDelegate.appController.arrayController removeObject:deadProject_arrayController];
    
    // Commit the change.
    NSError *error;
    
    [managedObjectContext deleteObject:deadObject];
    
    if ( ![managedObjectContext save:&error] )
    {
        // Handle the error.
    }
}

- (id)getProperty:(NSString *)propertyName forObjectID:(NSString *)objectID
{
    SHProject *project = nil;
    
    for ( SHProject *p in _projectsArray )
    {
        if ( [p.projectID isEqualToString:objectID] )
        {
            project = p;
        }
    }
    
    if ( [propertyName isEqualToString:@"deviceColor"] )
    {
        return project.deviceColor;
    }
    else if ( [propertyName isEqualToString:@"projectID"] )
    {
        return project.projectID;
    }
    else if ( [propertyName isEqualToString:@"projectName"] )
    {
        return project.projectName;
    }
    else if ( [propertyName isEqualToString:@"projectDateAdded"] )
    {
        return project.projectDateAdded;
    }
    else if ( [propertyName isEqualToString:@"projectType"] )
    {
        return project.projectType;
    }
    else if ( [propertyName isEqualToString:@"rootDirPath"] )
    {
        return project.rootDirPath;
    }
    else if ( [propertyName isEqualToString:@"projectFilePath"] )
    {
        return project.projectFilePath;
    }
    else if ( [propertyName isEqualToString:@"projectThumbnailImage"] )
    {
        return project.projectThumbnailImagePath_1;
    } else {
        return @"Error! Invalid property!";
    }
}

- (void)setProperty:(id)property forPropertyName:(NSString *)propertyName forObjectID:(NSString *)objectID
{
    if ([property isEqual:[NSNull null]]) {
        property = @"";
    }
    
    NSURL *objectURL = [NSURL URLWithString:objectID];
    NSManagedObject *newObject = [self objectWithURI:objectURL];
    
    SHProject *project = (SHProject *)newObject;
    SHProject *projectArrayRepresentation = nil;
    
    for ( SHProject *p in _projectsArray )
    {
        if ( [p.projectID isEqualToString:objectID] )
        {
            projectArrayRepresentation = p;
        }
    }
    
    if ( [propertyName isEqualToString:@"deviceColor"] )
    {
        project.deviceColor = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.deviceColor = property;
        }
    }
    else if ( [propertyName isEqualToString:@"projectID"] )
    {
        project.projectID = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.projectID = property;
        }
    }
    else if ( [propertyName isEqualToString:@"projectName"] )
    {
        project.projectName = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.projectName = property;
        }
    }
    else if ( [propertyName isEqualToString:@"projectDateAdded"] )
    {
        project.projectDateAdded = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.projectDateAdded = property;
        }
    }
    else if ( [propertyName isEqualToString:@"projectType"] )
    {
        project.projectType = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.projectType = property;
        }
    }
    else if ( [propertyName isEqualToString:@"rootDirPath"] )
    {
        project.rootDirPath = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.rootDirPath = property;
        }
    }
    else if ( [propertyName isEqualToString:@"projectFilePath"] )
    {
        project.projectFilePath = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.projectFilePath = property;
        }
    }
    else if ( [propertyName isEqualToString:@"projectThumbnailImage"] )
    {
        project.projectThumbnailImagePath_1 = property;
        
        if ( projectArrayRepresentation )
        {
            projectArrayRepresentation.projectThumbnailImagePath_1 = property;
        }
    }
    
    // Commit the change.
    NSError *error;
    
    if (![managedObjectContext save:&error]) {
        // Handle the error.
    }
}

@end
