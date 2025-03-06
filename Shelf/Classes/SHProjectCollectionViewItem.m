//
//  SHProjectCollectionViewItem.m
//  Shelf
//
//  Created by Ali Mahouk on 4/12/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "SHProjectCollectionViewItem.h"

@implementation SHProjectCollectionViewItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self )
    {
        container = (SHContainerBox *)self.view;
    }
    
    return self;
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    
    Project *p = (Project *)representedObject;
    container.project = p;
    
    [container setUpView];
}

@end
