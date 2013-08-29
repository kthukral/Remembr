//
//  EditItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-29.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "EditItemViewController.h"

@interface EditItemViewController ()

@end

@implementation EditItemViewController

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
    [self.editImageView setImage:self.itemToEdit.itemImage];
    [self.editTextView setText:self.itemToEdit.itemDescription];
    [self.editTitleTextField setText:self.itemToEdit.itemTitle];
    
    UINavigationItem *nav;
    nav.title = @"Remember";
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges:)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [[self navigationItem]setRightBarButtonItem:save];
    [[self navigationItem]setLeftBarButtonItem:cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveChanges:(id)sender{
    
}

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
