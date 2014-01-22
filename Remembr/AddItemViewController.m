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
    
    self.itemBeingCreated = [[Item alloc]init];
    
    //Base view setup
    
    self.view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    self.description.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    self.description.textColor = [UIColor lightGrayColor];
    self.description.text = @"Description";
    self.description.delegate = self;
    
    self.titleTextField.backgroundColor = [UIColor colorWithRed:0.38f green:0.37f blue:0.38f alpha:0.8f];
    self.titleTextField.textColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    self.titleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.itemImageView.backgroundColor = [UIColor colorWithRed:0.70f green:0.29f blue:0.23f alpha:1.00f];
    self.description.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    UINavigationItem *nav = [self navigationItem];
    
    nav.title = @"New Item";
    
    self.save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveItem:)];

    
    [[self navigationItem]setRightBarButtonItem:self.save];
    [self.description setScrollEnabled:YES];
    
    self.cameraButtonPlaceholder.hidden = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)preferredContentSizeChanged:(id)sender{
    self.description.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    if([self.titleTextField isFirstResponder]){
        [self.titleTextField resignFirstResponder];
    }else if([self.description isFirstResponder]){
        [self.description resignFirstResponder];
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromGallery];
        case 2:
            [self deletePhoto];
        default:
            break;
    }
}

- (void)deletePhoto{
    if(self.itemBeingCreated.hasImage){
        self.itemBeingCreated.hasImage = NO;
        [[ImageStore imageStore]deleteImageForKey:self.itemBeingCreated.imageKey];
        self.itemBeingCreated.imageKey = nil;
        self.itemImageView.image = nil;
        self.itemImageView.backgroundColor = [UIColor colorWithRed:0.70f green:0.29f blue:0.23f alpha:1.00f];
        self.cameraButtonPlaceholder.hidden = NO;
    }
}

- (void)takeNewPhotoFromCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [imagePicker setDelegate:self];
    
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)choosePhotoFromGallery{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveItem:(id)sender{
    if([_titleTextField isFirstResponder]){
        [_titleTextField resignFirstResponder];
    }else if([_description isFirstResponder]){
        [_description resignFirstResponder];
    }
    [self performSelector:@selector(addNewItem:) withObject:nil afterDelay:0.5];
}

- (void)addNewItem:(id)sender{
    NSString *descriptionStr = [NSString new];
    NSInteger initialCount = [[[ItemStore itemStore]passItemListForCategory:self.category]count];
    if(![_titleTextField.text isEqualToString:@""]){
        
        if ([_description.text isEqualToString:@"Description"] || [_description.text isEqualToString:@""]) {
            descriptionStr = @"";
        } else {
            descriptionStr = self.description.text;
        }
        
        [[ItemStore itemStore]createItemWithTitle:self.titleTextField.text withImageKey:self.itemBeingCreated.imageKey withDescription:descriptionStr hasImage:self.itemBeingCreated.hasImage withCategory:self.category];
        
        [[CategoryStore categoryStore]saveChanges];
        
        NSInteger newcount = [[[ItemStore itemStore]passItemListForCategory:self.category]count];
        if(initialCount == newcount) {
        
        } else {
            self.itemList = [[ItemListViewController alloc]init];
            self.itemList.categorySelected = self.category;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *invalidItemAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Item" message:@"The Item Must Have a Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    //To ensure that when the text view is the first responder, the view scrolls up to ensuare that the keyboard does not cover up text
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
    
    //View should go back to normal (scroll down) after text view resignes as first responder
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    if (self.description.text.length == 0) {
        self.description.textColor = [UIColor lightGrayColor];
        self.description.text = @"Description";
    }

    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //Description is hint text, should dissapear when first responder and appear when text view is empty
    if ([self.description.text isEqualToString:@"Description"]) {
        self.description.text = @"";
    }
    
    self.description.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);
    
    // Create a string from unique identifier
    CFStringRef newUniqueIDString =
    CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    
    [self.itemBeingCreated setImageKey:key];
    
    [[ImageStore imageStore]setImage:image forKey:[self.itemBeingCreated imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.itemImageView.clipsToBounds = YES;
    self.itemImageView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [self.itemImageView setImage:image];
    
    self.itemBeingCreated.hasImage = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.cameraButtonPlaceholder.hidden = YES;

}


- (IBAction)selectImage:(id)sender {
    
    if([self.titleTextField isFirstResponder]){
        [self.titleTextField resignFirstResponder];
    }else if([self.description isFirstResponder]){
        [self.description resignFirstResponder];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", @"Delete",nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)backgroundTapped:(id)sender {
    
    [[self view]endEditing:YES];
    

}
@end
