//
//  ItemStore.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Category.h"
#import "ImageStore.h"

@interface ItemStore : NSObject

+ (ItemStore *)itemStore;

- (NSArray *)passItemListForCategory:(Category *)category;

- (Item *)createItemWithTitle:(NSString *)title withDescription:(NSString *)description withCategory:(Category *)category;

- (Item *)createItemWithTitle:(NSString *)title withImageKey:(NSString *)imageKey withDescription:(NSString *)description withCategory:(Category *)category;

- (Item *)createItemWithTitle:(NSString *)title withImageKey:(NSString *)imageKey withDescription:(NSString *)description withCategory:(Category *)category replaceItemAtIndex:(NSInteger)index;

- (void)deleteItemAtIndex:(NSInteger)index withCategory:(Category *)parent;

- (void)addItem:(Item *)item ToCategory:(Category *)parent;

@end
