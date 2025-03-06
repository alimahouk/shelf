//
//  AppDelegate.h
//  Shelf
//
//  Created by Ali Mahouk on 3/20/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#define APP_NAME @"Shelf"
#define SH_DOMAIN @"scapehouse.com"
#define ROOT_PROJECTS_DIR @"Shelf Projects"

#import <Cocoa/Cocoa.h>
#import "AppController.h"
#import "ASIFormDataRequest.h"
#import "SHView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSTextFieldDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong) __block ASIFormDataRequest *dataRequest;
@property (strong) IBOutlet AppController *appController;
@property (strong) SHView *listViewUpperShadow;
@property (strong) SHView *listViewLowerShadow;

- (BOOL)isFullScreenMode;
- (NSImage *)highlightedImageForImage:(NSImage *)image;
- (IBAction)submitFeedback:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
