//
//  AppController.h
//  Shelf
//
//  Created by Ali Mahouk on 3/23/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHProjectController.h"

@interface AppController : NSViewController <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    SHProjectController *projectController;
    NSMutableArray *projectFiles;
    NSString *newProjectID;
    NSString *newProjectName;
    NSDate *newProjectDateAdded;
    NSString *newProjectType;
    NSString *newProjectRootDirPath;
    NSString *newProjectFilePath;
    NSString *newProjectThumbnailImagePath_1;
}

@property (assign) IBOutlet NSArrayController *arrayController;
@property (assign) IBOutlet NSCollectionView *projectList;
@property (assign) IBOutlet NSScrollView *projectListScrollView;
@property (assign) IBOutlet NSWindow *selectMainProjectSheet;
@property (assign) IBOutlet NSWindow *addProjectSheet;
@property (assign) IBOutlet NSView *rootView;
@property (assign) IBOutlet NSView *xcodeProjectDetailsView;
@property (assign) IBOutlet NSTableView *projectSelectionTable;
@property (strong) IBOutlet NSButton *addProjectButton;
@property (strong) IBOutlet NSButton *projectFromTemplateButton;
@property (strong) IBOutlet NSButton *createNewXcodeProjectButton;
@property (strong) IBOutlet NSPopUpButton *projectTypeButton;
@property (strong) IBOutlet NSTextField *projectNameField;
@property (strong) NSMutableArray *projects;

- (IBAction)addNewProject:(id)sender;
- (IBAction)closeProjectSheet:(id)sender;
- (IBAction)closeMainProjectSelectionSheet:(id)sender;
- (IBAction)newProjectFromExisting:(id)sender;
- (IBAction)newProjectFromTemplate:(id)sender;
- (IBAction)createNewXcodeProject:(id)sender;
- (IBAction)setMainProject:(id)sender;
- (void)selectMainProject;
- (void)finalizeProject;
- (void)renameFileAtPath:(NSString *)oldPath to:(NSString *)newPath;

@end
