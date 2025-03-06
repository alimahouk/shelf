//
//  SHView.m
//  Shelf
//
//  Created by Ali Mahouk on 4/5/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "SHView.h"

@implementation SHView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Create a blank image and lock drawing on it.
    NSImage *bigImage = [[NSImage alloc] initWithSize:self.bounds.size];
    [bigImage lockFocus];
    
    // Draw your image pattern on the new blank image.
    [backgroundColor set];
    NSRectFill(self.bounds);
    
    [bigImage unlockFocus];
    
    // draw your new image
    [bigImage drawInRect:self.bounds
                fromRect:NSZeroRect
               operation:NSCompositeSourceOver
                fraction:1.0f];
}

- (void)applyBackgroundColor:(NSColor *)color
{
    backgroundColor = color;
    
    [self setNeedsDisplay:YES];
}

- (BOOL)preservesContentDuringLiveResize
{
    return YES;
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    // don't allow any mouse clicks for subviews in this view
	if(NSPointInRect(aPoint,[self convertRect:[self bounds] toView:[self superview]])) {
		return self;
	} else {
		return nil;
	}
}

-(void)mouseDown:(NSEvent *)theEvent
{
	[super mouseDown:theEvent];
	
	// check for click count above one, which we assume means it's a double click
	if([theEvent clickCount] > 1) {
		NSLog(@"double click!");
		if(delegate && [delegate respondsToSelector:@selector(doubleClick:)]) {
			[delegate performSelector:@selector(doubleClick:) withObject:self];
		}
	}
}

@end
