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

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)addImageButton:(id)sender;
- (void)catergoryAlreadyExists;
- (void)createNewCategory;

@end
