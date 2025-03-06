//
//  SHProjectCollectionView.m
//  Shelf
//
//  Created by Ali Mahouk on 3/23/13.
//  Copyright (c) 2013 Ali Mahouk. All rights reserved.
//

#import "SHProjectCollectionView.h"
#import "AppDelegate.h"
#import "SHProjectCollectionViewItem.h"

@implementation SHProjectCollectionView

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)theObject
{
    SHProjectCollectionViewItem *item = [[SHProjectCollectionViewItem alloc] init];
    [item setRepresentedObject:theObject];
    
    return item;
}



@end
