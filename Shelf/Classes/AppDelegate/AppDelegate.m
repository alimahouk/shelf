//
//  AppDelegate.m
//  Shelf
//
//  Created by Ali Mahouk on 3/20/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    // It is important that setting up any views that rely on
    // fullscreen mode occur here. This function gets called
    // before any NSWindowDelegate methods.
    _listViewUpperShadow = [[SHView alloc] init];
    [_listViewUpperShadow applyBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"list_view_shadow_upper"]]];
    
    _listViewLowerShadow = [[SHView alloc] init];
    [_listViewLowerShadow applyBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"list_view_shadow_lower"]]];
    
    _listViewUpperShadow.frame = NSMakeRect(0, _window.frame.size.height - 144, _window.frame.size.width, 76);
    _listViewLowerShadow.frame = NSMakeRect(0, 0, _window.frame.size.width, 11);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_window.contentView addSubview:_listViewUpperShadow];
    [_window.contentView addSubview:_listViewLowerShadow];
}

#pragma mark -
#pragma mark NSWindowDelegate methods

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    // Make sure the shadows stay in place.
    _listViewUpperShadow.frame = NSMakeRect(0, frameSize.height - 144, frameSize.width, 76);
    _listViewLowerShadow.frame = NSMakeRect(0, 0, frameSize.width, 11);
    
    return frameSize;
}

- (NSSize)window:(NSWindow *)window willUseFullScreenContentSize:(NSSize)proposedSize
{
    _listViewUpperShadow.frame = NSMakeRect(0, proposedSize.height - 122, proposedSize.width, 76);
    _listViewLowerShadow.frame = NSMakeRect(0, 0, proposedSize.width, 11);
    
    return proposedSize;
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    _listViewUpperShadow.frame = NSMakeRect(0, _window.frame.size.height - 122, _window.frame.size.width, 76);
    _listViewLowerShadow.frame = NSMakeRect(0, 0, _window.frame.size.width, 11);
}

- (void)windowDidExitFullScreen:(NSNotification *)notification
{
    _listViewUpperShadow.frame = NSMakeRect(0, _window.frame.size.height - 144, _window.frame.size.width, 76);
    _listViewLowerShadow.frame = NSMakeRect(0, 0, _window.frame.size.width, 11);
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
    // Fix the position of sheets with respect to the height of the top
    // of the window frame.
    NSView *contentView = _window.contentView;
    NSRect contentViewRect = contentView.frame;
    
    contentViewRect.size.height = 135;
    contentViewRect.origin.y = _window.frame.size.height;
    return contentViewRect;
}

- (BOOL)isFullScreenMode
{
    NSApplicationPresentationOptions options = [[NSApplication sharedApplication] presentationOptions];
    
    if ( options & NSApplicationPresentationFullScreen )
    {
        return YES;
    }
    
    return NO;
}

// returns retained copy of image, with highlighting applied
- (NSImage *)highlightedImageForImage:(NSImage *)image
{
    NSImage *newImage;
    NSSize newSize;
    
    if ( !image ) return nil;
    
    newSize = [image size];
    newImage = [[NSImage alloc] initWithSize:newSize];
    [newImage lockFocus];
    [image drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, newSize.width, newSize.height) operation:NSCompositeSourceOver
              fraction:1.0];
    
    [[[NSColor blackColor] colorWithAlphaComponent:.5] set];
    NSRectFillUsingOperation(NSMakeRect(0, 0, newSize.width, newSize.height), NSCompositeSourceAtop);
    [newImage unlockFocus];
    
    return newImage;
}

- (IBAction)submitFeedback:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://scapehouse.com/corporate/contact"]];
}

// Handling the "Open Recent" menu.
-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    NSString *launchCommand = [NSString stringWithFormat:@"open '%@';", [filenames objectAtIndex:0]];
    system([launchCommand UTF8String]);
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "Scapehouse.Shelf" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"Scapehouse.Shelf"];
}

#pragma mark -
#pragma mark Core Data

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Shelf" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( _persistentStoreCoordinator )
    {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    
    if ( !mom )
    {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if ( !properties )
    {
        BOOL ok = NO;
        if ( [error code] == NSFileReadNoSuchFileError )
        {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        if ( !ok )
        {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else
    {
        if ( ![properties[NSURLIsDirectoryKey] boolValue] )
        {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Shelf.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    if ( ![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error] )
    {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if ( _managedObjectContext )
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if ( !coordinator )
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if ( ![[self managedObjectContext] commitEditing] )
    {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if ( ![[self managedObjectContext] save:&error] )
    {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if ( !_managedObjectContext )
    {
        return NSTerminateNow;
    }
    
    if ( ![[self managedObjectContext] commitEditing] )
    {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if ( ![[self managedObjectContext] hasChanges] )
    {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    
    if ( ![[self managedObjectContext] save:&error] )
    {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        
        if ( result )
        {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if ( answer == NSAlertAlternateReturn )
        {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
