//
//  AppController.m
//  Shelf
//
//  Created by Ali Mahouk on 3/23/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "AppController.h"
#import "AppDelegate.h"
#import "SHProject.h"
#import "Project.h"

@implementation AppController

- (IBAction)addNewProject:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [NSApp beginSheet:_addProjectSheet
       modalForWindow:appDelegate.window
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
}

- (IBAction)closeMainProjectSelectionSheet:(id)sender
{
    [projectFiles removeAllObjects]; // Clear this out.
    [NSApp endSheet:_selectMainProjectSheet];
}

- (IBAction)closeProjectSheet:(id)sender
{
    [NSApp endSheet:_addProjectSheet];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
    
    [_projectNameField setStringValue:@""];
    [_createNewXcodeProjectButton setEnabled:NO];
    [_projectFromTemplateButton setKeyEquivalent:@"\r"];
    
    _rootView.hidden = NO;
    _xcodeProjectDetailsView.hidden = YES;
    
    _rootView.alphaValue = 1.0;
    _xcodeProjectDetailsView.alphaValue = 0.0;
}

- (IBAction)newProjectFromExisting:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [self closeProjectSheet:nil];
    
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    
    [openDialog setAllowsMultipleSelection:NO];
    [openDialog setResolvesAliases:YES];
    [openDialog setCanChooseFiles:NO];         // Disable the selection of files in the dialog.
    [openDialog setCanChooseDirectories:YES];  // Enable the selection of directories in the dialog.
    [openDialog setPrompt:@"Select"];
    
    [openDialog beginSheetModalForWindow:appDelegate.window completionHandler:^(NSInteger result) {
        if ( result == NSFileHandlingPanelOKButton )
        {
            for ( NSURL *url in [openDialog URLs] )
            {
                // We need an app-scoped bookmark.
                NSData *bookmark = nil;
                NSError *bookmarkError = nil;
                bookmark = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
                         includingResourceValuesForKeys:nil
                                          relativeToURL:nil // Make it app-scoped
                                                  error:&bookmarkError];
                
                BOOL bookmarkDataIsStale;
                NSURL *bookmarkFileURL = [NSURL
                                   URLByResolvingBookmarkData:bookmark
                                   options:NSURLBookmarkResolutionWithSecurityScope
                                   relativeToURL:nil
                                   bookmarkDataIsStale:&bookmarkDataIsStale
                                   error:nil];
                
                NSString *urlString = [bookmarkFileURL path];
                NSString *projectName = [[urlString lastPathComponent] stringByDeletingPathExtension];
                NSInteger projectType;
                
                NSFileManager *fileManager= [NSFileManager defaultManager];
                NSString *rootDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:ROOT_PROJECTS_DIR];
                NSString *projectDirectory = [rootDirectory stringByAppendingPathComponent:projectName];
                BOOL isDir;
                
                [bookmarkFileURL startAccessingSecurityScopedResource]; // Sandboxing issues without this.
                
                // Create the root directory to hold all Shelf projects.
                if ( ![fileManager fileExistsAtPath:rootDirectory isDirectory:&isDir] )
                {
                    if ( ![fileManager createDirectoryAtPath:rootDirectory withIntermediateDirectories:YES attributes:nil error:NULL] )
                    {
                        NSLog(@"Error creating folder: %@", rootDirectory);
                    }
                }
                else
                {
                    // Do a check to see if a project with the same name already exists in our database.
                    for ( SHProject *p in _arrayController.arrangedObjects )
                    {
                        if ( [p.projectName isEqualToString:projectName] )
                        {
                            return; // GTFO.
                        }
                    }
                }
                
                if ( ![fileManager fileExistsAtPath:projectDirectory isDirectory:&isDir] )
                {
                    if ( ![fileManager moveItemAtPath:urlString toPath:projectDirectory error:nil] )
                    {
                        NSLog(@"Error creating folder: %@", projectDirectory);
                    }
                }
                
                // Checking project type.
                NSString *path_xcodeproj = [projectDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcodeproj", projectName]];
                NSString *path_pbxproj = [path_xcodeproj stringByAppendingPathComponent:@"project.pbxproj"];
                
                NSString *pbxprojContents = [NSString stringWithContentsOfFile:path_pbxproj
                                                                      encoding:NSUTF8StringEncoding
                                                                         error:nil];
                
                if ( [pbxprojContents rangeOfString:@"TARGETED_DEVICE_FAMILY = 2;"].location != NSNotFound ) // iPad
                {
                    projectType = 1;
                }
                else if ( [pbxprojContents rangeOfString:@"TARGETED_DEVICE_FAMILY = \"1,2\""].location != NSNotFound ) // Universal
                {
                    projectType = 2;
                }
                else if ( [pbxprojContents rangeOfString:@"MACOSX_DEPLOYMENT_TARGET"].location != NSNotFound ) // OS X
                {
                    projectType = 3;
                }
                else // iPhone
                {
                    projectType = 0;
                }
                
                newProjectName = projectName;
                newProjectType = [NSString stringWithFormat:@"%ld", (long)projectType];
                newProjectRootDirPath = projectDirectory;
                newProjectFilePath = path_xcodeproj;
                
                // Next, we need to parse everything in the project directory to find all .xcodeproj files.
                // Priority is for one named after the project. Otherwise, grab the 1st one you find.
                NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
                
                NSDirectoryEnumerator *enumerator = [fileManager
                                                     enumeratorAtURL:[NSURL fileURLWithPath:projectDirectory isDirectory:YES]
                                                     includingPropertiesForKeys:keys
                                                     options:0
                                                     errorHandler:^(NSURL *url, NSError *error) {
                                                         // Handle the error.
                                                         // Return YES if the enumeration should continue after the error.
                                                         return YES;
                                                     }];
                
                [projectFiles removeAllObjects]; // Start clean.
                
                for ( NSURL *url in enumerator )
                {
                    NSError *error;
                    NSNumber *isDirectory = nil;
                    
                    if ( ![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error] )
                    {
                        // Handle error.
                    }
                    else if ( ![isDirectory boolValue] )
                    {
                        NSString *urlString = [url path];
                        NSString *projectFilePath;
                        
                        // Search for .xcodeproj files.
                        if ( [urlString rangeOfString:@".xcodeproj" options:NSCaseInsensitiveSearch].location != NSNotFound )
                        {
                            NSScanner *scanner = [NSScanner scannerWithString:urlString];
                            BOOL matchFound = NO;
                            
                            // By default, NSScanner will skip whitespace - we don't want it to skip anything here.
                            [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
                            [scanner scanUpToString:@".xcodeproj" intoString:&projectFilePath];
                            projectFilePath = [projectFilePath stringByAppendingString:@".xcodeproj"];
                            
                            for (int i = 0; i < projectFiles.count; i++) // Save the paths in an array.
                            {
                                if ( [[projectFiles objectAtIndex:i] isEqualToString:projectFilePath] ) // We don't want duplicates.
                                {
                                    matchFound = YES;
                                    break;
                                }
                            }
                            
                            if ( !matchFound )
                            {
                                [projectFiles addObject:projectFilePath];
                            }
                        }
                    }
                }
                
                if ( projectFiles.count > 1 )
                {
                    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.45];
                    NSTimer *theTimer = [[NSTimer alloc] initWithFireDate:date
                                                                 interval:1
                                                                   target:self
                                                                 selector:@selector(selectMainProject)
                                                                 userInfo:nil repeats:NO];
                    NSRunLoop *runner = [NSRunLoop currentRunLoop];
                    [runner addTimer:theTimer forMode:NSDefaultRunLoopMode];
                }
                else
                {
                    [self finalizeProject];
                }
                
                [bookmarkFileURL stopAccessingSecurityScopedResource]; // Save system resources.
            }
        }
    }];
}

- (IBAction)newProjectFromTemplate:(id)sender
{
    [_rootView setWantsLayer:YES];
    _rootView.alphaValue = 1.0;
    [_rootView.animator setAlphaValue:0.0];
    
    _rootView.hidden = YES;
    _xcodeProjectDetailsView.hidden = NO;
    
    [_xcodeProjectDetailsView setWantsLayer:YES];
    _xcodeProjectDetailsView.alphaValue = 0.0;
    [_xcodeProjectDetailsView.animator setAlphaValue:1.0];
    
    [_createNewXcodeProjectButton setEnabled:NO];
    [_createNewXcodeProjectButton setKeyEquivalent:@"\r"];
    
    [_addProjectSheet makeFirstResponder:_projectNameField];
}

- (IBAction)createNewXcodeProject:(id)sender
{
    NSString *projectName = _projectNameField.stringValue;
    NSInteger projectType = _projectTypeButton.indexOfSelectedItem;
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *rootDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:ROOT_PROJECTS_DIR];
    NSString *templatePath;
    BOOL isDir;
    
    if ( projectType == 0 )
    {
        templatePath = [[NSBundle mainBundle] pathForResource:@"TemplateProject_iphone" ofType:@"app"];
    }
    else if ( projectType == 1 )
    {
        templatePath = [[NSBundle mainBundle] pathForResource:@"TemplateProject_ipad" ofType:@"app"];
    }
    else if ( projectType == 2 )
    {
        templatePath = [[NSBundle mainBundle] pathForResource:@"TemplateProject_universal" ofType:@"app"];
    }
    else if ( projectType == 4 ) // 3 is the separator item.
    {
        projectType = 3; // Push it back to avoid confusions past this point.
        templatePath = [[NSBundle mainBundle] pathForResource:@"TemplateProject_osx" ofType:@"app"];
    }
    
    // Create the root directory to hold all Shelf projects.
    if ( ![fileManager fileExistsAtPath:rootDirectory isDirectory:&isDir] )
    {
        if( ![fileManager createDirectoryAtPath:rootDirectory withIntermediateDirectories:YES attributes:nil error:NULL] )
        {
            NSLog(@"Error creating folder: %@", rootDirectory);
        }
    }
    
    // Copy the template over to it.
    NSString *projectDirectory = [rootDirectory stringByAppendingPathComponent:projectName];
    
    if( ![fileManager fileExistsAtPath:projectDirectory isDirectory:&isDir] )
    {
        if( ![fileManager copyItemAtPath:templatePath toPath:projectDirectory error:nil] )
        {
            NSLog(@"Error creating folder: %@", projectDirectory);
        }
    }
    
    // RENAMING FILES
    
    NSString *newName_plist = [NSString stringWithFormat:@"%@-Info.plist", projectName];
    NSString *newName_pch = [NSString stringWithFormat:@"%@-Prefix.pch", projectName];
    NSString *newName_xcodeproj = [NSString stringWithFormat:@"%@.xcodeproj", projectName];
    NSString *newName_xcscheme = [NSString stringWithFormat:@"%@.xcscheme", projectName];
    
    NSString *path_plist = [[projectDirectory stringByAppendingPathComponent:@"TemplateProject"] stringByAppendingPathComponent:@"TemplateProject-Info.plist"];
    NSString *path_pch = [[projectDirectory stringByAppendingPathComponent:@"TemplateProject"] stringByAppendingPathComponent:@"TemplateProject-Prefix.pch"];
    NSString *path_xib = [[[projectDirectory stringByAppendingPathComponent:@"TemplateProject"] stringByAppendingPathComponent:@"en.lproj"] stringByAppendingPathComponent:@"MainMenu.xib"];
    NSString *path_xcodeproj = [projectDirectory stringByAppendingPathComponent:@"TemplateProject.xcodeproj"];
    NSString *path_pbxproj = [path_xcodeproj stringByAppendingPathComponent:@"project.pbxproj"];
    NSString *path_xcworkspace = [[path_xcodeproj stringByAppendingPathComponent:@"project.xcworkspace"] stringByAppendingPathComponent:@"contents.xcworkspacedata"];
    NSString *path_xcuserstate = [[[[path_xcodeproj stringByAppendingPathComponent:@"project.xcworkspace"] stringByAppendingPathComponent:@"xcuserdata"] stringByAppendingPathComponent:@"MachOSX.xcuserdatad"] stringByAppendingPathComponent:@"UserInterfaceState.xcuserstate"];
    NSString *path_xcscheme = [[[[path_xcodeproj stringByAppendingPathComponent:@"xcuserdata"] stringByAppendingPathComponent:@"MachOSX.xcuserdatad"] stringByAppendingPathComponent:@"xcschemes"] stringByAppendingPathComponent:@"TemplateProject.xcscheme"];
    NSString *path_rootFolder = [projectDirectory stringByAppendingPathComponent:@"TemplateProject"];
    
    newProjectName = projectName;
    newProjectType = [NSString stringWithFormat:@"%ld", (long)projectType];
    newProjectRootDirPath = projectDirectory;
    newProjectFilePath = [projectDirectory stringByAppendingPathComponent:newName_xcodeproj];
    
    // Only the OS X template has a NIB file.
    if ( projectType == 4 )
    {
        // Modify name instances in the NIB file.
        NSString *NIBContents = [NSString stringWithContentsOfFile:path_xib
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
        
        NIBContents = [NIBContents stringByReplacingOccurrencesOfString:@"TemplateProject" withString:projectName];
        
        [NIBContents writeToFile:path_xib atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    // Modify name instances in the .pbxproj file.
    NSString *pbxprojContents = [NSString stringWithContentsOfFile:path_pbxproj
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
    
    pbxprojContents = [pbxprojContents stringByReplacingOccurrencesOfString:@"TemplateProject" withString:projectName];
    
    [pbxprojContents writeToFile:path_pbxproj atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    // Modify name instances in the .xcscheme file.
    NSString *xcschemeContents = [NSString stringWithContentsOfFile:path_xcscheme
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    xcschemeContents = [xcschemeContents stringByReplacingOccurrencesOfString:@"TemplateProject" withString:projectName];
    
    [xcschemeContents writeToFile:path_xcscheme atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Modify name instances in the .xcworkspace file.
    NSString *xcworkspaceContents = [NSString stringWithContentsOfFile:path_xcworkspace
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
    
    xcworkspaceContents = [xcworkspaceContents stringByReplacingOccurrencesOfString:@"TemplateProject" withString:projectName];
    
    [xcworkspaceContents writeToFile:path_xcworkspace atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Modify name instances in the .xcuserstate file.
    NSString *xcuserstateContents = [NSString stringWithContentsOfFile:path_xcuserstate
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
    
    xcuserstateContents = [xcuserstateContents stringByReplacingOccurrencesOfString:@"TemplateProject" withString:projectName];
    
    [xcuserstateContents writeToFile:path_xcuserstate atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self renameFileAtPath:path_plist to:newName_plist];
    [self renameFileAtPath:path_pch to:newName_pch];
    [self renameFileAtPath:path_xcscheme to:newName_xcscheme];
    [self renameFileAtPath:path_xcodeproj to:newName_xcodeproj];
    [self renameFileAtPath:path_rootFolder to:projectName];
    
    [self closeProjectSheet:nil];
    [self finalizeProject];
}

- (void)selectMainProject
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [NSApp beginSheet:_selectMainProjectSheet
       modalForWindow:appDelegate.window
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
    
    [_projectSelectionTable reloadData];
}

- (IBAction)setMainProject:(id)sender
{
    newProjectFilePath = [projectFiles objectAtIndex:[_projectSelectionTable selectedRow]];
    
    [self closeMainProjectSelectionSheet:nil];
    [self finalizeProject];
}

- (void)finalizeProject
{
    newProjectDateAdded = [NSDate date];
    newProjectThumbnailImagePath_1 = @"";
    
    NSURL *objectURL = [[projectController createNewProject] URIRepresentation];
    NSString *projectID = [objectURL absoluteString];
    NSInteger deviceColor = arc4random_uniform(2);
    
    [projectController setProperty:[NSString stringWithFormat:@"%ld", (long)deviceColor] forPropertyName:@"deviceColor" forObjectID:projectID];
    [projectController setProperty:projectID forPropertyName:@"projectID" forObjectID:projectID];
    [projectController setProperty:newProjectName forPropertyName:@"projectName" forObjectID:projectID];
    [projectController setProperty:newProjectDateAdded forPropertyName:@"projectDateAdded" forObjectID:projectID];
    [projectController setProperty:newProjectType forPropertyName:@"projectType" forObjectID:projectID];
    [projectController setProperty:newProjectRootDirPath forPropertyName:@"rootDirPath" forObjectID:projectID];
    [projectController setProperty:newProjectFilePath forPropertyName:@"projectFilePath" forObjectID:projectID];
    [projectController setProperty:newProjectThumbnailImagePath_1 forPropertyName:@"projectThumbnailImagePath_1" forObjectID:projectID];
    
    SHProject *p = [projectController.projectsArray objectAtIndex:0];
    [_arrayController addObject:p];
}

- (void)renameFileAtPath:(NSString *)oldPath to:(NSString *)newName
{
    NSString *temp = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"Shelf-temp"]];
    NSString *target = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
    
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:temp error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:temp toPath:target error:nil];
}

- (void)awakeFromNib
{
    _projectList.backgroundColors = @[[NSColor colorWithPatternImage:[NSImage imageNamed:@"hash_bg"]]];
    _projectListScrollView.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"hash_bg"]];
    
    projectController = [[SHProjectController alloc] init];
    
    projectFiles = [[NSMutableArray alloc] init]; // This will hold any .xcodeproj files found when importing a project.
    _projects = [[NSMutableArray alloc] init];
    
    for (SHProject *projectEntity in projectController.projectsArray) {
        Project *p = [[Project alloc] init];
        p.deviceColor = projectEntity.deviceColor;
        p.projectID = projectEntity.projectID;
        p.projectName = projectEntity.projectName;
        p.projectDateAdded = projectEntity.projectDateAdded;
        p.projectDateModified = projectEntity.projectDateModified;
        p.projectIcon = projectEntity.projectIcon;
        p.projectType = projectEntity.projectType;
        p.rootDirPath = projectEntity.rootDirPath;
        p.projectFilePath = projectEntity.projectFilePath;
        p.projectThumbnailImagePath_1 = projectEntity.projectThumbnailImagePath_1;
        [_arrayController addObject:p];
    }
    
    // Keyboard shortcut: Cmd + N
    [_addProjectButton setKeyEquivalentModifierMask:NSCommandKeyMask];
    [_addProjectButton setKeyEquivalent:@"n"];
    [_addProjectButton setToolTip:@"Add a new project"];
    [_addProjectButton setAction:@selector(addNewProject:)];
    [_addProjectButton setTarget:self];
    
    _projectNameField.delegate = self;
}

#pragma mark -
#pragma mark NSTableViewDelegate & NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [projectFiles count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *fileName = [[projectFiles objectAtIndex:row] lastPathComponent];
    
    return fileName;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return NO;
}

#pragma mark -
#pragma mark NSTextFieldDelegate methods

- (void)controlTextDidChange:(NSNotification*)aNotification
{
    if ( _projectNameField.stringValue.length > 0 )
    {
        [_createNewXcodeProjectButton setEnabled:YES];
    }
    else
    {
        [_createNewXcodeProjectButton setEnabled:NO];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    
}

@end
