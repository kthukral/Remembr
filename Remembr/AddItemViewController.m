//
//  AddItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@property (strong, nonatomic) UIBarButtonItem *save;
@property (strong, nonatomic) ItemListViewController *itemList;

@end

@implementation AddItemViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize description = _description;
@synthesize itemImageView = _itemImageView;
@synthesize titleTextField = _titleTextField;

CGFloat animatedDistance;

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
    UINavigationItem *nav = [self navigationItem];
    
    nav.title = @"New Item";
    
    self.save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveItem:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [[self navigationItem]setRightBarButtonItem:self.save];
    [self.description setScrollEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    if([self.titleTextField isFirstResponder]){
        [self.titleTextField resignFirstResponder];
    }else if([self.description isFirstResponder]){
        [self.description resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if([_titleTextField isFirstResponder]){
    [_titleTextField resignFirstResponder];
    }else if([_description isFirstResponder]){
    [_description resignFirstResponder];
    }
    [_titleTextField setText:@""];
    [_description setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveItem:(id)sender{
    if([_titleTextField isFirstResponder]){
        [_titleTextField resignFirstResponder];
    }else if([_description isFirstResponder]){
        [_description resignFirstResponder];
    }
    [self performSelector:@selector(addNewItem:) withObject:nil afterDelay:0.5];
}

- (IBAction)addNewItem:(id)sender{
    NSInteger initialCount = [[[ItemStore itemStore]passItemListForCategory:self.category]count];
    if(![_titleTextField.text isEqualToString:@""] && ![_description.text isEqualToString:@""]){
        [[ItemStore itemStore]createItemWithTitle:_titleTextField.text withImage:[UIImage imageNamed:@"logo.jpg"] withDescription:_description.text withCategory:self.category];
        NSInteger newcount = [[[ItemStore itemStore]passItemListForCategory:self.category]count];
        if(initialCount == newcount){
        
        }else{
            //self.itemList = [[ItemListViewController alloc]init];
            //self.itemList.categorySelected = self.category;
            [self.navigationController popViewControllerAnimated:YES]; 
        }
    }else{
        UIAlertView *invalidItemAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Item" message:@"The Item Must Have a Title and Description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidItemAlert show];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5* textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    
    CGFloat heightFraction = numerator/denominator;
    
    if(heightFraction<0.0){
        heightFraction = 0.0;
    }
    else if(heightFraction>1.0){
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textViewRect.origin.y + 0.5* textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    
    CGFloat heightFraction = numerator/denominator;
    
    if(heightFraction<0.0){
        heightFraction = 0.0;
    }
    else if(heightFraction>1.0){
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];

    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}


@end
