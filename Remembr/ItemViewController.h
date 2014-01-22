//
//  NewItemViewController.h
//  Remembr
//
//  Created by Karan Thukral on 10/24/2013.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "Item.h"
#import "CategoryStore.h"
#import "ImageStore.h"
#import "EditItemViewController.h"
#import <MWPhotoBrowser.h>

@interface ItemViewController : UIViewController <MWPhotoBrowserDelegate>

@property (nonatomic, strong) Category *categorySelected;

@property (nonatomic, assign) NSInteger itemIndex;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) UIButton *button;
@end
