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

@interface EditExistingCategoryViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) Category *categoryToBeEditied;

@property (weak, nonatomic) IBOutlet UITextField *categoryTitleField;
@property (weak, nonatomic) IBOutlet UIButton *imageViewButton;

@property (assign, nonatomic) NSInteger index;

@end
