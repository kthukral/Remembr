//
//  AddCategoryViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "AddCategoryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddCategoryViewController ()

@property (strong, nonatomic) UIBarButtonItem *save;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation AddCategoryViewController

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
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector (textFieldTextChanged:)
                               name:UITextFieldTextDidChangeNotification
                             object:self.titleTextField];
    
    UIColor *backgroundLabels = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    self.view.backgroundColor = backgroundLabels;
    
    [self.titleTextField setHidden:YES];
    self.titleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    self.tempCategory = [[Category alloc]init];
    
    self.iconCollectionView.delegate = self;
    self.iconCollectionView.dataSource = self;
    
    self.backgroundCollectionView.delegate = self;
    self.backgroundCollectionView.dataSource = self;
    
    self.iconCollectionView.backgroundColor = [UIColor whiteColor];
    [self.iconCollectionView setShowsHorizontalScrollIndicator:NO];
    
    self.backgroundCollectionView.backgroundColor = [UIColor whiteColor];
    [self.backgroundCollectionView setShowsHorizontalScrollIndicator:NO];
    
    [self.iconCollectionView registerClass:[collectionViewCellCustom class] forCellWithReuseIdentifier:@"cell"];
    [self.backgroundCollectionView registerClass:[collectionViewCellCustom class] forCellWithReuseIdentifier:@"cell"];

    self.titleTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.iconArray = [[NSArray alloc]initWithArray:[[collectionStore collectionStore]returnIconPack]];
    self.backgroundColorArray = [[NSArray alloc]initWithArray:[[collectionStore collectionStore]returnColors]];
    
    UINavigationItem *nav = [self navigationItem];
    
    nav.title = @"New Category";
    
    self.save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveCategory:)];

    
    [[self navigationItem]setRightBarButtonItem:self.save];
    
    [self.titleTextField becomeFirstResponder];
    
    
}

- (void)textFieldTextChanged:(id)sender{
    self.navigationItem.title = self.titleTextField.text;
    [self.tempCategory setTitle:self.titleTextField.text];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
    [self.save setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidDisappear:(BOOL)animated{
    [_titleTextField setText:@""];
}

- (void)catergoryAlreadyExists{
    UIAlertView *existingCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Category Already Exists" message:@"This Category Already Exists. Please use a different title." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [existingCategoryAlert show];
    
}

- (IBAction)saveCategory:(id)sender{
    
//    [_titleTextField resignFirstResponder];
    [self performSelector:@selector(createNewCategory)  withObject:nil afterDelay:0.5];
    
    //checking if valid string

    
}

- (void)createNewCategory{
    
     NSInteger initialcount = [[[CategoryStore categoryStore]allCatagories] count];
    
    if(![_titleTextField.text isEqualToString:@""]){

        
        if(self.tempCategory.imageName && self.tempCategory.categoryColor){
        
        [[CategoryStore categoryStore]createCategoryWithTitle:self.tempCategory.title withColor:self.tempCategory.categoryColor andImageName:self.tempCategory.imageName withIndex:self.tempCategory.imageIndex];
            
               NSInteger newCount = [[[CategoryStore categoryStore]allCatagories] count];
        if(initialcount == newCount){
            
        }else{
            
            CustomCollectionViewCell *iconSelectedCell = (CustomCollectionViewCell *)[self.iconCollectionView cellForItemAtIndexPath:self.currentIconSelected];
            iconSelectedCell.alpha = 1.0f;
            CustomCollectionViewCell *backgroundSelectedCell = (CustomCollectionViewCell *)[self.backgroundCollectionView cellForItemAtIndexPath:self.currentBackgroundSelected];
            backgroundSelectedCell.alpha = 1.0f;

            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        }else{
            UIAlertView *invalidCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Category" message:@"The Category Must Have an Icon and Background" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [invalidCategoryAlert show];
        }
        
    }else{
        UIAlertView *invalidCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Category" message:@"The Category Must Have a Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidCategoryAlert show];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.save setEnabled:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.iconCollectionView){
        return self.iconArray.count;
    }else{
        return self.backgroundColorArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.iconCollectionView){
        collectionViewCellCustom *Customcell = (collectionViewCellCustom *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [[Customcell backgroundImage]setImage:[self.iconArray objectAtIndex:indexPath.row]];
        Customcell.backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
        Customcell.backgroundImage.clipsToBounds = YES;
        [Customcell setAlpha:1];
        return Customcell;
    }else{
        collectionViewCellCustom *Customcell = (collectionViewCellCustom *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        Customcell.backgroundColor = [self.backgroundColorArray objectAtIndex:indexPath.row];
                return Customcell;
        
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.iconCollectionView){
        NSString *imageIndex = [NSString stringWithFormat:@"%d",indexPath.row];
        NSString *selectedImageName = [imageIndex stringByAppendingString:@".png"];
        self.tempCategory.imageName = selectedImageName;
        self.tempCategory.imageIndex = indexPath.row;
        collectionViewCellCustom *cell = (collectionViewCellCustom *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setAlpha:0.5f];
        [cell.layer setBorderColor:(__bridge CGColorRef)([UIColor blueColor])];
        cell.layer.borderWidth = 3.0f;
        self.currentIconSelected = indexPath;
        
    }else if(collectionView == self.backgroundCollectionView){
        
        UIColor *colorSelected = [self.backgroundColorArray objectAtIndex:indexPath.row];
        self.tempCategory.categoryColor = colorSelected;
        collectionViewCellCustom *cell = (collectionViewCellCustom *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setAlpha:0.5f];
        self.currentBackgroundSelected = indexPath;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionViewCellCustom *cell = (collectionViewCellCustom *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setAlpha:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSelector:@selector(createNewCategory)  withObject:nil afterDelay:0.5];
    return NO;
}

@end
