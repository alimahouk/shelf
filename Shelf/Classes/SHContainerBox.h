//
//  SHContainerBox.h
//  Shelf
//
//  Created by Ali Mahouk on 4/12/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHProjectController.h"
#import "Project.h"
#import "ThinImageView.h"

@interface SHContainerBox : NSBox <NSAlertDelegate, NSTextFieldDelegate> {
    SHProjectController *projectController;
    NSMutableArray *tempImages;
    ThinImageView *device_primary;
    ThinImageView *deviceGlare_primary;
    ThinImageView *deviceShadow_primary;
    ThinImageView *deviceReflection_primary;
    ThinImageView *screenshot1_primary;
    ThinImageView *device_auxiliary;
    ThinImageView *deviceGlare_auxiliary;
    ThinImageView *deviceReflection_auxiliary;
    ThinImageView *screenshot1_auxiliary;
    NSTextField *projectNameLabel;
    NSTextField *projectNameLabelShadow;
    NSMenu *projectContextMenu;
    BOOL shouldOpenProject;
    BOOL projectIsBeingRenamed;
}

@property (strong) Project *project;

- (void)setUpView;
- (void)showProjectInFinder;
- (void)renameProject;
- (void)confirmRenamingProject;
- (void)renameProjectByRenamingFiles:(BOOL)renameFiles;
- (void)renameFiles;
- (void)cancelProjectRenaming;
- (void)confirmRemoveProject;
- (void)removeProjectByMovingToTrash:(BOOL)moveToTrash;
- (void)runTerminalCommand;

@end
