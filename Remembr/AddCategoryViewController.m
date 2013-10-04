//
//  AddCategoryViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "ImageStore.h"

@interface AddCategoryViewController ()

@property (strong, nonatomic) UIBarButtonItem *save;

@end

@implementation AddCategoryViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

CGFloat animatedDistance;

@synthesize titleTextField = _titleTextField;

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
    self.categoryToBeCreated = [[Category alloc]init];
    UINavigationItem *nav = [self navigationItem];
    
    nav.title = @"New Category";
    
    self.save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveCategory:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [[self navigationItem]setRightBarButtonItem:self.save];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.save setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidDisappear:(BOOL)animated{
    if([self.titleTextField isFirstResponder]){
        [self.titleTextField resignFirstResponder];
    }
    self.imageView.image = nil;
    [_titleTextField setText:@""];
}

- (void)catergoryAlreadyExists{
    UIAlertView *existingCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Category Already Exists" message:@"This Category Already Exists. Please use a different title." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [existingCategoryAlert show];
    
}

- (IBAction)saveCategory:(id)sender{
    
    [_titleTextField resignFirstResponder];
    [self performSelector:@selector(createNewCategory)  withObject:nil afterDelay:0.5];
    
    //checking if valid string

    
}

- (void)createNewCategory{
    
     NSInteger initialcount = [[[CategoryStore categoryStore]allCatagories] count];
    
    if(![_titleTextField.text isEqualToString:@""]){
        if(self.imageView.image){
            
            [self.categoryToBeCreated setTitle:self.titleTextField.text];
            [[CategoryStore categoryStore]addNewCategory:self.categoryToBeCreated];
            
        }else{
            
            CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
            CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
            NSString *key = (__bridge NSString *)newUniqueIDString;
            
            [[ImageStore imageStore]setImage:self.categoryImage forKey:key];
            
            CFRelease(newUniqueIDString);
            CFRelease(newUniqueID);
            
            Category *category = [[CategoryStore categoryStore]createCategoryWithTitle:self.titleTextField.text];
            
            [category setImageKey:key];
            
            [[ImageStore imageStore]setImage:[UIImage imageNamed:@"logo.jpeg"] forKey:[category imageKey]];
            
        }
        NSInteger newCount = [[[CategoryStore categoryStore]allCatagories] count];
        if(initialcount == newCount){
            
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }else{
        UIAlertView *invalidCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Category" message:@"The Category Must Have a Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidCategoryAlert show];
    }
}

- (IBAction)addImageButton:(id)sender {
    
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc]initWithTitle:@"Add Category Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a new photo", @"Choose from existing", nil];
    [photoActionSheet showFromToolbar:self.navigationController.toolbar];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
            case 1:
            [self choosePhotoFromGallery];
            
        default:
            break;
    }
}

- (void) takeNewPhotoFromCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *cameraController = [[UIImagePickerController alloc]init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.allowsEditing = NO;
        cameraController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        cameraController.delegate = self;
//        [self presentModalViewController:cameraController animated:YES];
        [self presentViewController:cameraController animated:YES completion:nil];
    }else{
        UIAlertView *noCameraAlert = [[UIAlertView alloc]initWithTitle:@"No Camera Available" message:@"A camera was not detected on the device" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [noCameraAlert show];
    }
}

- (void) choosePhotoFromGallery{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *galleryController = [[UIImagePickerController alloc]init];
        galleryController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        galleryController.allowsEditing = YES;
        galleryController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        galleryController.delegate = self;
        [self presentViewController:galleryController animated:YES completion:nil];
    }else{
        UIAlertView *noGalleryAlert = [[UIAlertView alloc]initWithTitle:@"No Access to Gallery" message:@"Remembr does not have access to your photos. Pleas enable access in Settings -> Privacy -> Photos" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [noGalleryAlert show];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.save setEnabled:YES];
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
    
    [self.categoryToBeCreated setTitle:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.categoryImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);
    
    // Create a string from unique identifier
    CFStringRef newUniqueIDString =
    CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    
    [self.categoryToBeCreated setImageKey:key];
    
    [[ImageStore imageStore]setImage:image forKey:[self.categoryToBeCreated imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    [self.imageView setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
