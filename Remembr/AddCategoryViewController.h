//
//  AddCategoryViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "CategoryStore.h"
#import "CategoryViewController.h"
#import "collectionStore.h"
#import "collectionViewCellCustom.h"

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *backgroundCollectionView;

@property (strong, nonatomic) NSArray *iconArray;
@property (strong, nonatomic) NSArray *backgroundColorArray;

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;

@property (strong, nonatomic) Category *tempCategory;

- (void)catergoryAlreadyExists;
- (void)createNewCategory;

@end
