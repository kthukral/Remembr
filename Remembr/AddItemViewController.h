//
//  AddItemViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemStore.h"
#import "Category.h"
#import "ItemListViewController.h"
#import "ImageStore.h"

@interface AddItemViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) Category *category;

@property (strong, nonatomic) Item *itemBeingCreated;
- (IBAction)selectImage:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
