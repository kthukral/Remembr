//
//  EditCategoriesViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-09-22.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryStore.h"
#import "CategoryViewController.h"
#import "CustomTableViewCell.h"
#import "EditExistingCategoryViewController.h"
#import "editCategoryTableViewCell.h"
#import <BVReorderTableView/BVReorderTableView.h>

@interface EditCategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ReorderTableViewDelegate>

@end
