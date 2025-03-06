//
//  SHContainerBox.m
//  Shelf
//
//  Created by Ali Mahouk on 4/12/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "SHContainerBox.h"
#import "AppDelegate.h"
#import "YRKSpinningProgressIndicatorLayer.h"

@implementation SHContainerBox

- (void)setUpView
{
    shouldOpenProject = YES;
    projectIsBeingRenamed = NO;
    
    projectController = [[SHProjectController alloc] init];
    tempImages = [[NSMutableArray alloc] init];
    
    device_primary = [[ThinImageView alloc] init];
    deviceGlare_primary = [[ThinImageView alloc] init];
    deviceShadow_primary = [[ThinImageView alloc] init];
    deviceReflection_primary = [[ThinImageView alloc] init];
    screenshot1_primary = [[ThinImageView alloc] init];
    
    device_auxiliary = [[ThinImageView alloc] init];
    deviceGlare_auxiliary = [[ThinImageView alloc] init];
    deviceReflection_auxiliary = [[ThinImageView alloc] init];
    screenshot1_auxiliary = [[ThinImageView alloc] init];
    
    NSString *imageName_device_primary = @"";
    NSString *imageName_glare_primary = @"";
    NSString *imageName_shadow_primary = @"";
    NSString *imageName_reflection_primary = @"";
    NSString *imageName_placeholder_primary = @"";
    
    NSString *imageName_device_auxiliary = @"";
    NSString *imageName_glare_auxiliary = @"";
    NSString *imageName_reflection_auxiliary = @"";
    NSString *imageName_placeholder_auxiliary = @"";
    
    if ( [_project.projectType intValue] == 0 )
    {
        if ( [_project.deviceColor intValue] == 0 )
        {
            imageName_device_primary = @"device_iphone_black";
            imageName_reflection_primary = @"device_reflection_iphone_black";
        }
        else
        {
            imageName_device_primary = @"device_iphone_white";
            imageName_reflection_primary = @"device_reflection_iphone_white";
        }
        
        imageName_glare_primary = @"glare_iphone_portrait";
        imageName_shadow_primary = @"device_shadow_iphone";
        imageName_placeholder_primary = @"placeholder_iphone_portrait";
        
        device_primary.frame = NSMakeRect(125, 30, 200, 352);
        deviceGlare_primary.frame = NSMakeRect(210, 96, 82, 330);
        deviceShadow_primary.frame = NSMakeRect(82, 0, 274, 440);
        deviceReflection_primary.frame = NSMakeRect(149, 17, 149, 50);
        screenshot1_primary.frame = NSMakeRect(158, 111, 129, 226);
    }
    else if ( [_project.projectType intValue] == 1 )
    {
        if ( [_project.deviceColor intValue] == 0 )
        {
            imageName_device_primary = @"device_ipad_black";
            imageName_reflection_primary = @"device_reflection_ipad_black";
        }
        else
        {
            imageName_device_primary = @"device_ipad_white";
            imageName_reflection_primary = @"device_reflection_ipad_white";
        }
        
        imageName_glare_primary = @"glare_ipad_portrait";
        imageName_shadow_primary = @"device_shadow_ipad";
        imageName_placeholder_primary = @"placeholder_ipad_portrait";
        
        device_primary.frame = NSMakeRect(61, -15, 328, 440);
        deviceGlare_primary.frame = NSMakeRect(203, 82, 157, 342);
        deviceShadow_primary.frame = NSMakeRect(24, 0, 397, 484);
        deviceReflection_primary.frame = NSMakeRect(84, 17, 278, 48);
        screenshot1_primary.frame = NSMakeRect(114, 100, 221, 294);
    }
    else if ( [_project.projectType intValue] == 2 )
    {
        if ( [_project.deviceColor intValue] == 0 )
        {
            imageName_device_primary = @"device_ipad_black";
            imageName_reflection_primary = @"device_reflection_ipad_black";
            imageName_device_auxiliary = @"device_iphone_black_small";
            imageName_reflection_auxiliary = @"device_reflection_iphone_black_small";
        }
        else
        {
            imageName_device_primary = @"device_ipad_white";
            imageName_reflection_primary = @"device_reflection_ipad_white";
            imageName_device_auxiliary = @"device_iphone_white_small";
            imageName_reflection_auxiliary = @"device_reflection_white_black_small";
        }
        
        imageName_glare_primary = @"glare_ipad_portrait";
        imageName_shadow_primary = @"device_shadow_ipad";
        imageName_placeholder_primary = @"placeholder_ipad_portrait";
        imageName_glare_auxiliary = @"glare_iphone_portrait_small";
        imageName_placeholder_auxiliary = @"placeholder_iphone_portrait_small";
        
        device_primary.frame = NSMakeRect(61, -15, 328, 440);
        deviceGlare_primary.frame = NSMakeRect(203, 82, 157, 342);
        deviceShadow_primary.frame = NSMakeRect(24, 0, 397, 484);
        deviceReflection_primary.frame = NSMakeRect(84, 17, 278, 48);
        screenshot1_primary.frame = NSMakeRect(114, 100, 221, 294);
        
        device_auxiliary.frame = NSMakeRect(241, 25, 155, 280);
        deviceGlare_auxiliary.frame = NSMakeRect(261, 34, 157, 342);
        deviceReflection_auxiliary.frame = NSMakeRect(268, 25, 107, 36);
        screenshot1_auxiliary.frame = NSMakeRect(269, 94, 98, 171);
    }
    else
    {
        imageName_device_primary = @"device_macbook";
        imageName_reflection_primary = @"device_reflection_macbook";
        imageName_glare_primary = @"glare_macbook";
        imageName_shadow_primary = @"device_shadow_macbook";
        imageName_placeholder_primary = @"placeholder_macbook";
        
        device_primary.frame = NSMakeRect(20, 90, 405, 242);
        deviceGlare_primary.frame = NSMakeRect(263, 137, 125, 194);
        deviceShadow_primary.frame = NSMakeRect(0, 35, 425, 335);
        screenshot1_primary.frame = NSMakeRect(69, 126, 307, 193);
    }

    [tempImages addObject:imageName_device_primary];
    [tempImages addObject:imageName_glare_primary];
    [tempImages addObject:imageName_placeholder_primary];
    [tempImages addObject:imageName_device_auxiliary];
    [tempImages addObject:imageName_glare_auxiliary];
    [tempImages addObject:imageName_placeholder_auxiliary];
    
    device_primary.image = [NSImage imageNamed:imageName_device_primary];
    deviceGlare_primary.image = [NSImage imageNamed:imageName_glare_primary];
    deviceShadow_primary.image = [NSImage imageNamed:imageName_shadow_primary];
    deviceReflection_primary.image = [NSImage imageNamed:imageName_reflection_primary];
    screenshot1_primary.image = [NSImage imageNamed:imageName_placeholder_primary];
    
    device_auxiliary.image = [NSImage imageNamed:imageName_device_auxiliary];
    deviceGlare_auxiliary.image = [NSImage imageNamed:imageName_glare_auxiliary];
    deviceReflection_auxiliary.image = [NSImage imageNamed:imageName_reflection_auxiliary];
    screenshot1_auxiliary.image = [NSImage imageNamed:imageName_placeholder_auxiliary];
    
    projectNameLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(50, 7, 345, 20)];
    projectNameLabel.textColor = [NSColor whiteColor];
    projectNameLabel.alignment = NSCenterTextAlignment;
    projectNameLabel.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    projectNameLabel.delegate = self;
    [projectNameLabel setBezeled:NO];
    [projectNameLabel setDrawsBackground:NO];
    [projectNameLabel setEditable:NO];
    [projectNameLabel setSelectable:NO];
    [projectNameLabel setStringValue:_project.projectName];
    
    projectNameLabelShadow = [[NSTextField alloc] initWithFrame:NSMakeRect(50, 5, 345, 20)];
    projectNameLabelShadow.textColor = [NSColor blackColor];
    projectNameLabelShadow.alignment = NSCenterTextAlignment;
    projectNameLabelShadow.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    [projectNameLabelShadow setBezeled:NO];
    [projectNameLabelShadow setDrawsBackground:NO];
    [projectNameLabelShadow setEditable:NO];
    [projectNameLabelShadow setSelectable:NO];
    [projectNameLabelShadow setStringValue:_project.projectName];
    
    projectContextMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [projectContextMenu insertItemWithTitle:@"Show in Finder" action:@selector(showProjectInFinder) keyEquivalent:@"" atIndex:0];
    [projectContextMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
    [projectContextMenu insertItemWithTitle:@"Rename" action:@selector(renameProject) keyEquivalent:@"" atIndex:2];
    [projectContextMenu insertItemWithTitle:@"Delete" action:@selector(confirmRemoveProject) keyEquivalent:@"" atIndex:3];
    [projectContextMenu insertItem:[NSMenuItem separatorItem] atIndex:4];
    [projectContextMenu insertItemWithTitle:@"Run Terminal Command" action:@selector(runTerminalCommand) keyEquivalent:@"" atIndex:5];
    
    [self addSubview:deviceShadow_primary];
    [self addSubview:deviceReflection_primary];
    [self addSubview:device_primary];
    [self addSubview:screenshot1_primary];
    [self addSubview:deviceGlare_primary];
    
    [self addSubview:deviceReflection_auxiliary];
    [self addSubview:device_auxiliary];
    [self addSubview:screenshot1_auxiliary];
    [self addSubview:deviceGlare_auxiliary];
    
    [self addSubview:projectNameLabelShadow];
    [self addSubview:projectNameLabel];
    
    [self setMenu:projectContextMenu];
    [self addTrackingRect:self.frame owner:self userData:NULL assumeInside:NO]; // Set up proper tracking area for the entire view.
}

#pragma mark -
#pragma mark Click handling

- (void)mouseDown:(NSEvent *)theEvent
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    if ( !projectIsBeingRenamed )
    {
        device_primary.image = [appDelegate highlightedImageForImage:device_primary.image];
        deviceGlare_primary.image = [appDelegate highlightedImageForImage:deviceGlare_primary.image];
        screenshot1_primary.image = [appDelegate highlightedImageForImage:screenshot1_primary.image];
        
        if ( theEvent.modifierFlags & NSControlKeyMask )
        {NSLog(@"fuck");
            shouldOpenProject = NO;
            [super rightMouseDown:theEvent];
        }
        else
        {
            shouldOpenProject = YES;
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if ( !projectIsBeingRenamed )
    {
        device_primary.image = [NSImage imageNamed:[tempImages objectAtIndex:0]];
        deviceGlare_primary.image = [NSImage imageNamed:[tempImages objectAtIndex:1]];
        screenshot1_primary.image = [NSImage imageNamed:[tempImages objectAtIndex:2]];
        
        if ( !shouldOpenProject ) // If this was a Ctrl-click, don't open the project.
        {
            shouldOpenProject = YES; // Reset this.
            return;
        }
        
        [self setWantsLayer:YES];
        YRKSpinningProgressIndicatorLayer *progressIndicator = [[YRKSpinningProgressIndicatorLayer alloc] init];
        progressIndicator.name = @"progressIndicator";
        progressIndicator.anchorPoint = CGPointMake(0.0, 0.0);
        progressIndicator.position = CGPointMake(198, 195);
        progressIndicator.color = [NSColor whiteColor];
        progressIndicator.bounds = NSMakeRect(0, 0, 50, 50);
        progressIndicator.autoresizingMask = (kCALayerWidthSizable | kCALayerHeightSizable);
        [progressIndicator startProgressAnimation];
        
        [self.layer addSublayer:progressIndicator];
        
        // Open the project.
        NSString *launchCommand = [NSString stringWithFormat:@"cd '%@'; open %@", _project.rootDirPath, [_project.projectFilePath lastPathComponent]];
        
        system([launchCommand UTF8String]);
        
        // Delay and then hide the progress spinner.
        long double delayInSeconds = 1.0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setWantsLayer:NO];
            [progressIndicator stopProgressAnimation];
            [progressIndicator removeFromSuperlayer];
            
            [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:_project.projectFilePath]];
        });
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    device_primary.image = [NSImage imageNamed:[tempImages objectAtIndex:0]];
    deviceGlare_primary.image = [NSImage imageNamed:[tempImages objectAtIndex:1]];
    screenshot1_primary.image = [NSImage imageNamed:[tempImages objectAtIndex:2]];
    shouldOpenProject = NO;
}

#pragma mark -
#pragma mark Show in Finder

- (void)showProjectInFinder
{
    NSURL *rootDirPath = [NSURL fileURLWithPath:_project.rootDirPath];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[rootDirPath]];
}

#pragma mark -
#pragma mark Renaming

- (void)renameProject
{
    projectIsBeingRenamed = YES;
    shouldOpenProject = NO; // Disable this.
    projectNameLabel.frame = NSMakeRect(50, 5, 345, 26);
    projectNameLabel.textColor = [NSColor blackColor];
    [projectNameLabel setEditable:YES];
    [projectNameLabel setBezeled:YES];
    [projectNameLabel setDrawsBackground:YES];
    [projectNameLabel becomeFirstResponder];
}

- (void)confirmRenamingProject
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Rename All"];
    [alert addButtonWithTitle:@"Rename Reference"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Rename the Project?"];
    [alert setInformativeText:[NSString stringWithFormat:@"Do you want to rename all project files of “%@”, or only rename the reference to it in %@?", _project.projectName, APP_NAME]];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    NSInteger buttonIndex = [alert runModal];
    
    if ( buttonIndex == NSAlertFirstButtonReturn ) // Move to Trash
    {
        [self renameProjectByRenamingFiles:YES];
    }
    else if ( buttonIndex == NSAlertSecondButtonReturn) // Remove Reference
    {
        [self renameProjectByRenamingFiles:NO];
    }
    else if ( buttonIndex == NSAlertThirdButtonReturn) // Cancel
    {
        [self cancelProjectRenaming];
    }
    
    projectIsBeingRenamed = NO;
    shouldOpenProject = YES; // Re-enable this.
    
    projectNameLabel.frame = NSMakeRect(50, 7, 345, 20);
    projectNameLabel.textColor = [NSColor whiteColor];
    [projectNameLabel setBezeled:NO];
    [projectNameLabel setDrawsBackground:NO];
    [projectNameLabel setEditable:NO];
    [projectNameLabel setSelectable:NO];
}

- (void)renameProjectByRenamingFiles:(BOOL)renameFiles
{
    _project.projectName = projectNameLabel.stringValue;
    
    [projectController setProperty:_project.projectName forPropertyName:@"projectName" forObjectID:_project.projectID];
    
    if ( renameFiles )
    {
        [self renameFiles];
    }
    
    [projectNameLabelShadow setStringValue:_project.projectName]; // This contains a reference to what the project's name formerly was. Save it till the end.
}

- (void)renameFiles
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *oldProjectName = projectNameLabelShadow.stringValue;
    NSString *newName_plist = [NSString stringWithFormat:@"%@-Info.plist", _project.projectName];
    NSString *newName_pch = [NSString stringWithFormat:@"%@-Prefix.pch", _project.projectName];
    NSString *newName_xcodeproj = [NSString stringWithFormat:@"%@.xcodeproj", _project.projectName];
    NSString *newName_xcscheme = [NSString stringWithFormat:@"%@.xcscheme", _project.projectName];
    
    NSString *path_plist = [[_project.rootDirPath stringByAppendingPathComponent:oldProjectName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-Info.plist", oldProjectName]];
    NSString *path_pch = [[_project.rootDirPath stringByAppendingPathComponent:oldProjectName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-Prefix.pch", oldProjectName]];
    NSString *path_xib = [[[_project.rootDirPath stringByAppendingPathComponent:oldProjectName] stringByAppendingPathComponent:@"en.lproj"] stringByAppendingPathComponent:@"MainMenu.xib"];
    NSString *path_xcodeproj = [_project.rootDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcodeproj", oldProjectName]];
    NSString *path_pbxproj = [path_xcodeproj stringByAppendingPathComponent:@"project.pbxproj"];
    NSString *path_xcworkspace = [[path_xcodeproj stringByAppendingPathComponent:@"project.xcworkspace"] stringByAppendingPathComponent:@"contents.xcworkspacedata"];
    NSString *path_xcuserstate = [[[[path_xcodeproj stringByAppendingPathComponent:@"project.xcworkspace"] stringByAppendingPathComponent:@"xcuserdata"] stringByAppendingPathComponent:@"MachOSX.xcuserdatad"] stringByAppendingPathComponent:@"UserInterfaceState.xcuserstate"];
    NSString *path_xcscheme = [[[[path_xcodeproj stringByAppendingPathComponent:@"xcuserdata"] stringByAppendingPathComponent:@"MachOSX.xcuserdatad"] stringByAppendingPathComponent:@"xcschemes"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcscheme", oldProjectName]];
    NSString *path_rootFolder = [_project.rootDirPath stringByAppendingPathComponent:oldProjectName];
    
    // Next, we need to parse everything in the project directory to find all NIB files.
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSMutableArray *NIBFiles = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:[NSURL fileURLWithPath:_project.rootDirPath isDirectory:YES]
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];
    
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
            
            // Search for NIB files.
            if ( [urlString rangeOfString:@".xib" options:NSCaseInsensitiveSearch].location != NSNotFound )
            {
                NSScanner *scanner = [NSScanner scannerWithString:urlString];
                BOOL matchFound = NO;
                
                // By default, NSScanner will skip whitespace - we don't want it to skip anything here.
                [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
                [scanner scanUpToString:@".xib" intoString:&projectFilePath];
                projectFilePath = [projectFilePath stringByAppendingString:@".xib"];
                
                for (int i = 0; i < NIBFiles.count; i++) // Save the paths in an array.
                {
                    if ( [[NIBFiles objectAtIndex:i] isEqualToString:projectFilePath] ) // We don't want duplicates.
                    {
                        matchFound = YES;
                        break;
                    }
                }
                
                if ( !matchFound )
                {
                    [NIBFiles addObject:projectFilePath];
                }
            }
        }
        
        for ( NSString *NIBPath in NIBFiles )
        {
            // Modify name instances in the NIB file.
            NSString *NIBContents = [NSString stringWithContentsOfFile:NIBPath
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
            
            NIBContents = [NIBContents stringByReplacingOccurrencesOfString:oldProjectName withString:_project.projectName];
            
            [NIBContents writeToFile:path_xib atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    
    // Modify name instances in the .pbxproj file.
    NSString *pbxprojContents = [NSString stringWithContentsOfFile:path_pbxproj
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
    
    pbxprojContents = [pbxprojContents stringByReplacingOccurrencesOfString:oldProjectName withString:_project.projectName];
    
    [pbxprojContents writeToFile:path_pbxproj atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    // Modify name instances in the .xcscheme file.
    NSString *xcschemeContents = [NSString stringWithContentsOfFile:path_xcscheme
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    xcschemeContents = [xcschemeContents stringByReplacingOccurrencesOfString:oldProjectName withString:_project.projectName];
    
    [xcschemeContents writeToFile:path_xcscheme atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Modify name instances in the .xcworkspace file.
    NSString *xcworkspaceContents = [NSString stringWithContentsOfFile:path_xcworkspace
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
    
    xcworkspaceContents = [xcworkspaceContents stringByReplacingOccurrencesOfString:oldProjectName withString:_project.projectName];
    
    [xcworkspaceContents writeToFile:path_xcworkspace atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Modify name instances in the .xcuserstate file.
    NSString *xcuserstateContents = [NSString stringWithContentsOfFile:path_xcuserstate
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
    
    xcuserstateContents = [xcuserstateContents stringByReplacingOccurrencesOfString:oldProjectName withString:_project.projectName];
    
    [xcuserstateContents writeToFile:path_xcuserstate atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [appDelegate.appController renameFileAtPath:path_plist to:newName_plist];
    [appDelegate.appController renameFileAtPath:path_pch to:newName_pch];
    [appDelegate.appController renameFileAtPath:path_xcscheme to:newName_xcscheme];
    [appDelegate.appController renameFileAtPath:path_xcodeproj to:newName_xcodeproj];
    [appDelegate.appController renameFileAtPath:path_rootFolder to:_project.projectName];
    [appDelegate.appController renameFileAtPath:_project.rootDirPath to:_project.projectName];
    
    NSURL *oldRootDirPath = [NSURL fileURLWithPath:_project.rootDirPath];
    NSString *oldRootDirPathLastComponent = [oldRootDirPath lastPathComponent];
    NSRange oldRootDirPathFragmentRange = [_project.rootDirPath rangeOfString:oldRootDirPathLastComponent options:NSBackwardsSearch];
    
    // Chop the fragment.
    _project.rootDirPath = [_project.rootDirPath substringToIndex:oldRootDirPathFragmentRange.location];
    _project.rootDirPath = [_project.rootDirPath stringByAppendingString:_project.projectName];
    
    NSURL *oldProjectFilePath = [NSURL fileURLWithPath:_project.projectFilePath];
    NSString *oldProjectFilePathLastComponent = [oldProjectFilePath lastPathComponent];
    NSRange oldProjectFilePathFragmentRange = [_project.projectFilePath rangeOfString:oldProjectFilePathLastComponent options:NSBackwardsSearch];
    
    _project.projectFilePath = [_project.projectFilePath substringToIndex:oldProjectFilePathFragmentRange.location];
    _project.projectFilePath = [_project.projectFilePath stringByAppendingFormat:@"%@.xcodeproj", _project.projectName];
    
    [projectController setProperty:_project.rootDirPath forPropertyName:@"rootDirPath" forObjectID:_project.projectID];
    [projectController setProperty:_project.projectFilePath forPropertyName:@"projectFilePath" forObjectID:_project.projectID];
}

- (void)cancelProjectRenaming
{
    projectIsBeingRenamed = NO;
    shouldOpenProject = YES; // Re-enable this.
    
    projectNameLabel.frame = NSMakeRect(50, 7, 345, 20);
    projectNameLabel.textColor = [NSColor whiteColor];
    [projectNameLabel setBezeled:NO];
    [projectNameLabel setDrawsBackground:NO];
    [projectNameLabel setEditable:NO];
    [projectNameLabel setSelectable:NO];
    
    projectNameLabel.stringValue = _project.projectName;
}

#pragma mark -
#pragma mark Deleting

- (void)confirmRemoveProject
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Move to Trash"];
    [alert addButtonWithTitle:@"Remove Reference"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Delete the Project?"];
    [alert setInformativeText:[NSString stringWithFormat:@"Do you want to move the project “%@” to the Trash, or only remove the reference to it?", _project.projectName]];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    NSInteger buttonIndex = [alert runModal];
    
    if ( buttonIndex == NSAlertFirstButtonReturn ) // Move to Trash
    {
        [self removeProjectByMovingToTrash:YES];
    }
    else if ( buttonIndex == NSAlertSecondButtonReturn) // Remove Reference
    {
        [self removeProjectByMovingToTrash:NO];
    }
}

- (void)removeProjectByMovingToTrash:(BOOL)moveToTrash
{
    if ( moveToTrash )
    {
        [[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation
                                                     source:[_project.rootDirPath stringByDeletingLastPathComponent]
                                                destination:@""
                                                      files:[NSArray arrayWithObject:[_project.rootDirPath lastPathComponent]]
                                                        tag:nil];
    }
    
    [projectController deleteObjectWithID:_project.projectID];
}

#pragma mark -
#pragma mark Run Terminal Command

- (void)runTerminalCommand
{
    // Open the project.
    NSString *launchCommand = [NSString stringWithFormat:@"open -a Terminal.app --args cd '%@'", _project.rootDirPath];
    
    system([launchCommand UTF8String]);
}

#pragma mark -
#pragma mark NSTextFieldDelegate methods

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    if ( projectNameLabel.stringValue.length > 0 )
    {
        if ( [projectNameLabel.stringValue isEqualToString:_project.projectName] )
        {
            [self cancelProjectRenaming];
        }
        else
        {
           [self confirmRenamingProject]; 
        }
    }
    else
    {
        [self cancelProjectRenaming];
    }

}

@end
