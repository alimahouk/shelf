//
//  ThinImageView.m
//  Shelf
//
//  Created by Ali Mahouk on 4/14/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "ThinImageView.h"

@implementation ThinImageView

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        // Initialization code here.
    }
    
    return self;
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    return nil;
}

@end
