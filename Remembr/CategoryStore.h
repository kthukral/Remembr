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

- (Category *)createCategoryWithTitle:(NSString *)title withImage:(UIImage *)image;
- (NSArray *)allCatagories;
- (Category *)createCategoryWithTitle:(NSString *)title;

- (NSString *)itemArchievePath;
- (BOOL)saveChanges;
@end
