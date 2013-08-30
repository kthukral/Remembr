//
//  EditItemViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-29.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"
#import "Item.h"
#import "Category.h"

@interface EditItemViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;

@property (strong, nonatomic) Item *itemToEdit;
@property (strong, nonatomic) Category *parent;

@property (assign, nonatomic) NSInteger index;

@end
