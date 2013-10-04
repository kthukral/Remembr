//
//  ItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-29.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@property (strong, nonatomic) EditItemViewController *editItemView;

@end

@implementation ItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Item *item = [self.parentCategory.itemArray objectAtIndex:self.indexSelected];

    [self.itemTitleView setText:item.itemTitle];
//    [self.itemImageView setImage:item.itemImage];
    [self.itemDescriptionView setText:item.itemDescription];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [[self navigationItem]setRightBarButtonItem:edit];
    [self.itemDescriptionView setScrollEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    Item *item = [self.parentCategory.itemArray objectAtIndex:self.indexSelected];
    
    [self.itemTitleView setText:item.itemTitle];
//    [self.itemImageView setImage:item.itemImage];
    [self.itemDescriptionView setText:item.itemDescription];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editItem:(id)sender{
    self.editItemView = [[EditItemViewController alloc]initWithNibName:@"EditItemViewController" bundle:nil];
    self.editItemView.itemToEdit = self.itemToPopulate;
    self.editItemView.parent = self.parentCategory;
    self.editItemView.index = self.indexSelected;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.editItemView];
    //[self.navigationController pushViewController:self.editItemView animated:YES];
    [self presentModalViewController:nav animated:YES];
}



@end
