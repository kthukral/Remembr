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
    
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.itemImageView.clipsToBounds = YES;
    
    [self.itemTitleView setText:item.itemTitle];
    self.itemImageView.image = [[ImageStore imageStore]imageForKey:item.imageKey];
    [self.itemDescriptionView setText:item.itemDescription];
    
    UIColor *backgroundLabels = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];;
    self.view.backgroundColor = backgroundLabels;
    
    self.itemTitleView.backgroundColor = [UIColor colorWithRed:0.38f green:0.37f blue:0.38f alpha:0.8f];
    
    self.itemDescriptionView.backgroundColor = backgroundLabels;

    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [[self navigationItem]setRightBarButtonItem:edit];
    [self.itemDescriptionView setScrollEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewWillAppear:(BOOL)animated{
    Item *item = [self.parentCategory.itemArray objectAtIndex:self.indexSelected];
    
    [self.itemTitleView setText:item.itemTitle];
    [self.itemDescriptionView setText:item.itemDescription];
    [self.itemImageView setImage:[[ImageStore imageStore]imageForKey:item.imageKey]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editItem:(id)sender{
    
    EditItemViewController *editItemView;
    editItemView = [[EditItemViewController alloc]initWithNibName:@"EditItemViewController" bundle:nil];
    
    editItemView.itemToEdit = [self.parentCategory.itemArray objectAtIndex:self.indexSelected];
    editItemView.parent = self.parentCategory;
    editItemView.index = self.indexSelected;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editItemView];
    
    [self presentViewController:nav animated:YES completion:nil];
}



@end
