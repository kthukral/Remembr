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
    
    [self.itemTitleView setText:self.itemToPopulate.itemTitle];
    [self.itemImageView setImage:self.itemToPopulate.itemImage];
    [self.itemDescriptionView setText:self.itemToPopulate.itemDescription];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    [[self navigationItem]setRightBarButtonItem:edit];
    self.scrollView.contentSize = CGSizeMake(320, 1000);
}

- (void)viewDidAppear:(BOOL)animated{
    [self.itemTitleView setText:self.itemToPopulate.itemTitle];
    [self.itemImageView setImage:self.itemToPopulate.itemImage];
    [self.itemDescriptionView setText:self.itemToPopulate.itemDescription];
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

- (void)updateItemto:(Item *)item{
    self.itemToPopulate = item;
}

@end
