//
//  CategoryStore.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "CategoryViewController.h"

@interface CategoryStore : NSObject <UIAlertViewDelegate>
{
    NSMutableArray *allCatagories;
}


+ (CategoryStore *)categoryStore;

- (NSArray *)allCatagories;
- (Category *)createCategoryWithTitle:(NSString *)title;

- (Category *)createCategoryWithTitle:(NSString *)title withColor:(UIColor *)color andImageName:(NSString *)iName;

- (Category *)createCategoryWithTitle:(NSString *)title withColor:(UIColor *)color andImageName:(NSString *)iName withIndex:(int)index;

- (NSString *)itemArchievePath;

- (BOOL)saveChanges;

- (void)updateCategoryArray:(NSMutableArray *)newArray;

- (void)addNewCategory:(Category *)category;



@end
