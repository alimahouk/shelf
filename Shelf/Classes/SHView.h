//
//  SHView.h
//  Shelf
//
//  Created by Ali Mahouk on 4/5/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SHView : NSView {
    IBOutlet id delegate;
    
    NSColor *backgroundColor;
}

- (void)applyBackgroundColor:(NSColor *)color;

@end
