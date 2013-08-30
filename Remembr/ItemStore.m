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

- (Item *)createItemWithTitle:(NSString *)title withImage:(UIImage *)image withDescription:(NSString *)description withCategory:(Category *)category{
    
    Item *newItem = [[Item alloc]initWithTitle:title withImage:image withDescription:description];
    [category.itemArray insertObject:newItem atIndex:0];
    NSLog(@"%@",[[category.itemArray objectAtIndex:0] itemTitle]);
    return newItem;
}

- (NSArray *)passItemListForCategory:(Category *)category{
    return category.itemArray;
}

- (Item *)createItemWithTitle:(NSString *)title withImage:(UIImage *)image withDescription:(NSString *)description withCategory:(Category *)category replaceItemAtIndex:(NSInteger)index{
    Item *newItem;
    newItem = [[Item alloc]initWithTitle:title withImage:image withDescription:description];
    [category.itemArray removeObjectAtIndex:index];
    [category.itemArray insertObject:newItem atIndex:index];
    return newItem;
}



@end
