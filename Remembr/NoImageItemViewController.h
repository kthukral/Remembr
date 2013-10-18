//
//  NoImageItemViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-10-17.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "EditItemViewController.h"

@interface NoImageItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) Category *parentCategory;

@property (assign, nonatomic)NSInteger indexSelected;


@end
