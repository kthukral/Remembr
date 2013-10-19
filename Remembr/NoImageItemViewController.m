//
//  NoImageItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-10-17.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "NoImageItemViewController.h"
#import "Item.h"

@interface NoImageItemViewController ()

@end

@implementation NoImageItemViewController

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
    [self.titleLabel setText:item.itemTitle];
    [self.descriptionTextView setText:item.itemDescription];
    self.descriptionTextView.editable = NO;
    [self.descriptionTextView setScrollEnabled:YES];
    
    UIColor *backgroundLabels = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];;
    self.view.backgroundColor = backgroundLabels;
    self.descriptionTextView.backgroundColor = backgroundLabels;
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0.38f green:0.37f blue:0.38f alpha:0.8f];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [[self navigationItem]setRightBarButtonItem:edit];

    
}

- (void)editItem:(id)sender{
    
    EditItemViewController *editItemView = [[EditItemViewController alloc]initWithNibName:@"EditItemViewController" bundle:nil];
    
    editItemView.itemToEdit = [self.parentCategory.itemArray objectAtIndex:self.indexSelected];
    editItemView.parent = self.parentCategory;
    editItemView.index = self.indexSelected;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editItemView];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
