//
//  NewItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 10/24/2013.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "NewItemViewController.h"

@interface NewItemViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *descriptionTextView;

@end

@implementation NewItemViewController

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
	// Do any additional setup after loading the view.
    
    Item *itemToDisplay = [self.categorySelected.itemArray objectAtIndex:self.itemIndex];
    
    if(itemToDisplay.hasImage){
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.imageView.image = [[ImageStore imageStore]imageForKey:itemToDisplay.imageKey];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        
    } else {
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height, 320, 45)];
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, self.titleLabel.frame.origin.y + 50, 310, self.view.frame.size.height - 5 - self.imageView.frame.size.height - 45)];
    
    [self.titleLabel setText:itemToDisplay.itemTitle];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.descriptionTextView setText:itemToDisplay.itemDescription];
    
    UIColor *background = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];;
    self.view.backgroundColor = background;
    
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0.38f green:0.37f blue:0.38f alpha:0.8f];
    
    self.descriptionTextView.backgroundColor = background;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [[self navigationItem]setRightBarButtonItem:edit];
    [self.descriptionTextView setScrollEnabled:YES];

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descriptionTextView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
}

- (void)editItem:(id)sender{
    
    EditItemViewController *editItemView;
    editItemView = [[EditItemViewController alloc]initWithNibName:@"EditItemViewController" bundle:nil];
    
    editItemView.itemToEdit = [self.categorySelected.itemArray objectAtIndex:self.itemIndex];
    editItemView.parent = self.categorySelected;
    editItemView.index = self.itemIndex;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editItemView];
    
    [self presentViewController:nav animated:YES completion:nil];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
