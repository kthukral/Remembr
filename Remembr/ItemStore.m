//
//  ItemStore.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "ItemStore.h"

@implementation ItemStore

- (id)init
{
    self = [super init];
    
    if (self) {
        
}
    
    return self;
}

+ (ItemStore *)itemStore{
    
    static ItemStore * itemStore = nil;
    if (!itemStore) {
        itemStore = [[super allocWithZone:nil] init];
    }
    
    return itemStore;
    
}

- (Item *)createItemWithTitle:(NSString *)title withImageKey:(NSString *)imageKey withDescription:(NSString *)description withCategory:(Category *)category{
    
    Item *newItem = [[Item alloc]initWithTitle:title withImageKey:imageKey withDescription:description];
    [category.itemArray insertObject:newItem atIndex:0];
    NSLog(@"%@",[[category.itemArray objectAtIndex:0] itemTitle]);
    return newItem;
}

- (NSArray *)passItemListForCategory:(Category *)category{
    return category.itemArray;
}

- (Item *)createItemWithTitle:(NSString *)title withImageKey:(NSString *)imageKey withDescription:(NSString *)description withCategory:(Category *)category replaceItemAtIndex:(NSInteger)index{
    Item *newItem;
    newItem = [[Item alloc]initWithTitle:title withImageKey:imageKey withDescription:description];
    [category.itemArray removeObjectAtIndex:index];
    [category.itemArray insertObject:newItem atIndex:index];
    return newItem;
}

- (void)deleteItemAtIndex:(NSInteger)index withCategory:(Category *)parent{
    
    Item *item = [parent.itemArray objectAtIndex:index];
    NSString *key = item.imageKey;
    
    [[ImageStore imageStore]deleteImageForKey:key];
    
    [parent.itemArray removeObjectAtIndex:index];
}

- (Item *)createItemWithTitle:(NSString *)title withDescription:(NSString *)description withCategory:(Category *)category{
    
    Item *newItem = [[Item alloc]initWithTitle:title withDescription:description];
    [category.itemArray insertObject:newItem atIndex:0];
    NSLog(@"%@",[[category.itemArray objectAtIndex:0] itemTitle]);
    return newItem;

    
}

- (void)addItem:(Item *)item ToCategory:(Category *)parent{
    [parent.itemArray insertObject:item atIndex:0];
}



@end
