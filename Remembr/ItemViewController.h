//
//  ItemViewController.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-29.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemListViewController.h"
#import "ItemStore.h"
#import "EditItemViewController.h"
#import "Category.h"

@interface ItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleView;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionView;

@property (strong, nonatomic) Item *itemToPopulate;
@property (strong, nonatomic) Category *parentCategory;

@property (assign, nonatomic)NSInteger indexSelected;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)updateItemto:(Item *)item;

@end
