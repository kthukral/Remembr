//
//  EditItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-29.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "EditItemViewController.h"
#import "CategoryStore.h"

@interface EditItemViewController ()

@end

@implementation EditItemViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

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
	// Do any additional setup after loading the view.
    
    UIMenuItem *strikethrough = [[UIMenuItem alloc]initWithTitle:@"Strike" action:@selector(strikeTheSelection:)];

    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:strikethrough, nil]];
    
    self.editImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.editImageView.clipsToBounds = YES;
    self.navigationItem.title = self.itemToEdit.itemTitle;
    self.view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    self.editTextView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    
    self.editTitleTextField.backgroundColor = [UIColor colorWithRed:0.38f green:0.37f blue:0.38f alpha:0.8f];
    self.editTitleTextField.textColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    self.editTitleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.editTextView setAttributedText:self.itemToEdit.attrDescription];
    
    if (self.editTextView.text.length == 0) {
        self.editTextView.textColor = [UIColor lightGrayColor];
        self.editTextView.text = @"Description";
    }
    
    [self.editTitleTextField setText:self.itemToEdit.itemTitle];
    [self.editTextView setScrollEnabled:YES];
    self.editTextView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    if(self.itemToEdit.hasImage == YES){
        self.editImageView.image = [[ImageStore imageStore]imageForKey:self.itemToEdit.imageKey];
        self.cameraButtonPlaceholder.hidden = YES;
    } else {
        [self.editImageView setImage:nil];
        self.editImageView.backgroundColor = [UIColor colorWithRed:0.70f green:0.29f blue:0.23f alpha:1.00f];
        self.cameraButtonPlaceholder.hidden = NO;
    }
    
    UINavigationItem *nav;
    nav.title = @"Remember";
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges:)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];

    [[self navigationItem]setRightBarButtonItem:save];
    [[self navigationItem]setLeftBarButtonItem:cancel];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29f green:0.61f blue:0.85f alpha:1.00f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];

}

- (void)preferredContentSizeChanged:(id)sender{
    self.editTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.editTitleTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    if([self.editTextView isFirstResponder]){
        [self.editTextView resignFirstResponder];
    }else if([self.editTitleTextField isFirstResponder]){
        [self.editTitleTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveChanges:(id)sender{
    
    if([self.editTextView isFirstResponder]){
        [self.editTextView resignFirstResponder];
    }else if([self.editTitleTextField isFirstResponder]){
        [self.editTitleTextField resignFirstResponder];
    }
    
    if(self.changedImage && self.itemToEdit.hasImage){
    [[ImageStore imageStore]deleteImageForKey:self.itemToEdit.imageKey];
    [[ImageStore imageStore]setImage:self.changedImage forKey:self.itemToEdit.imageKey];
    }
    
    if(!self.itemToEdit.hasImage){
        self.itemToEdit.hasImage = self.didAddImageToNoImageItem;
    }
    
    self.itemToEdit.itemTitle = self.editTitleTextField.text;
    if ([self.editTextView.text isEqualToString:@"Description"]) {
        self.itemToEdit.itemDescription = @"";
    } else {
        self.itemToEdit.itemDescription = self.editTextView.attributedText.string;
        self.itemToEdit.attrDescription = self.editTextView.attributedText;
    }
    
    if (self.didDeleteImage){
        if (self.itemToEdit.hasImage||self.didAddImageToNoImageItem){
            self.itemToEdit.hasImage = NO;
            [[ImageStore imageStore]deleteImageForKey:self.itemToEdit.imageKey];
            self.itemToEdit.imageKey = nil;

        }
    }
    
    [self performSelector:@selector(cancelPressed:) withObject:nil afterDelay:0.5];
    
}

- (IBAction)cancel:(id)sender{
    if([self.editTextView isFirstResponder]){
        [self.editTextView resignFirstResponder];
    }else if([self.editTitleTextField isFirstResponder]){
        [self.editTitleTextField resignFirstResponder];
    }
    [self performSelector:@selector(cancelPressed:) withObject:nil afterDelay:0.5];
}

- (IBAction)cancelPressed:(id)sender{
    if(!self.itemToEdit.hasImage && self.itemToEdit.imageKey){
        [[ImageStore imageStore]deleteImageForKey:self.itemToEdit.imageKey];
        self.itemToEdit.imageKey = nil;
    }
    [[CategoryStore categoryStore]saveChanges];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (self.editTextView.text.length == 0) {
        self.editTextView.textColor = [UIColor lightGrayColor];
        self.editTextView.text = @"Description";
    }

    
}


- (IBAction)changeImage:(id)sender {
    if([self.editTitleTextField isFirstResponder]){
        [self.editTitleTextField resignFirstResponder];
    }else if([self.editTextView isFirstResponder]){
        [self.editTextView resignFirstResponder];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", @"Delete", nil];
    [actionSheet showInView:self.view];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.editTextView.text isEqualToString:@"Description"]) {
        self.editTextView.text = @"";
    }
    self.editTextView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
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
        self.editImageView.backgroundColor = [UIColor colorWithRed:0.70f green:0.29f blue:0.23f alpha:1.00f];
        self.editImageView.image = nil;
        self.cameraButtonPlaceholder.hidden = NO;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(!self.itemToEdit.hasImage){
        
        // Create a CFUUID object - it knows how to create unique identifier strings
        CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);
        
        // Create a string from unique identifier
        CFStringRef newUniqueIDString =
        CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
        
        // Use that unique ID to set our item's imageKey
        NSString *key = (__bridge NSString *)newUniqueIDString;
        
        [self.itemToEdit setImageKey:key];
        
        [[ImageStore imageStore]setImage:image forKey:[self.itemToEdit imageKey]];
        
        CFRelease(newUniqueIDString);
        CFRelease(newUniqueID);
        
        [self.editImageView setImage:image];
        
        self.didAddImageToNoImageItem = YES;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        self.cameraButtonPlaceholder.hidden = YES;
        
    } else {
        self.changedImage = [[UIImage alloc]init];
        self.changedImage = image;
        [self.editImageView setImage:self.changedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.editImageView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
}

- (void)strikeTheSelection:(id)sender {
    
    for (int i = 0; i<self.itemToEdit.rangesForStrike.count; i++) {
        NSRange range = [[self.itemToEdit.rangesForStrike objectAtIndex:i] rangeValue];
        if (NSEqualRanges(range, self.editTextView.selectedRange)) {
            [self.itemToEdit.rangesForStrike removeObjectAtIndex:i];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
            
            attrStr = (NSMutableAttributedString *)self.editTextView.attributedText;
            
            NSDictionary* strikeThroughAttributes = [NSDictionary new];
            
            [attrStr removeAttribute:NSStrikethroughStyleAttributeName range:self.editTextView.selectedRange];
            
            strikeThroughAttributes = @{NSStrikethroughStyleAttributeName : @0,NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSStrikethroughColorAttributeName:[UIColor redColor]};
            
            [attrStr setAttributes:strikeThroughAttributes range:self.editTextView.selectedRange];
            
            self.editTextView.text = @"";
            self.editTextView.attributedText = attrStr;
            
            return;
            
        }
    }
    
    [self.itemToEdit.rangesForStrike addObject:[NSValue valueWithRange:self.editTextView.selectedRange]];
    
    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
    
    attrStr = (NSMutableAttributedString *)self.editTextView.attributedText;
    
    NSDictionary* strikeThroughAttributes = [NSDictionary new]; //FIGURE OUT HOW TO REMOVE ATTR
    
    [attrStr removeAttribute:NSStrikethroughStyleAttributeName range:self.editTextView.selectedRange];
    
    strikeThroughAttributes = @{NSStrikethroughStyleAttributeName : @1,NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSStrikethroughColorAttributeName:[UIColor redColor]};
    
    [attrStr setAttributes:strikeThroughAttributes range:self.editTextView.selectedRange];
    
    self.editTextView.text = @"";
    self.editTextView.attributedText = attrStr;
    
}


@end
