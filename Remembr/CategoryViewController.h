//
//  CategoryViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "CategoryStore.h"
#import "AddCategoryViewController.h"
#import "CustomCollectionViewCell.h"
#import "ItemListViewController.h"
#import "EditCategoriesViewController.h"
#import "collectionStore.h"
#import <LXReorderableCollectionViewFlowLayout.h>

@interface CategoryViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, LXReorderableCollectionViewDatasource, LXReorderableCollectionViewDelegate>


- (IBAction)addNewCategory:(id)sender;
@property (strong, nonatomic) NSMutableArray *categories;

@end
