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

@interface ItemStore : NSObject

+ (ItemStore *)itemStore;

- (NSArray *)passItemListForCategory:(Category *)category;

- (Item *)createItemWithTitle:(NSString *)title withImage:(UIImage *)image withDescription:(NSString *)description withCategory:(Category *)category;

- (Item *)createItemWithTitle:(NSString *)title withImage:(UIImage *)image withDescription:(NSString *)description withCategory:(Category *)category replaceItemAtIndex:(NSInteger)index;

- (void)deleteItemAtIndex:(NSInteger)index withCategory:(Category *)parent;

@end
