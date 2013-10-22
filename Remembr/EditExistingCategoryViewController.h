//
//  EditExistingCategoryViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-09-23.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "CategoryStore.h"
#import "EditCategoriesViewController.h"
#import "collectionStore.h"
#import "collectionViewCellCustom.h"

@interface EditExistingCategoryViewController : UIViewController <UITextFieldDelegate , UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) Category *categoryToBeEditied;

@property (weak, nonatomic) IBOutlet UITextField *categoryTitleField;

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *backgroundCollectionView;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *editedImageName;
@property (strong, nonatomic) UIColor *editedColor;
@property (strong, nonatomic) NSArray *iconArray;
@property (strong, nonatomic) NSArray *backgroundColorArray;

@end
