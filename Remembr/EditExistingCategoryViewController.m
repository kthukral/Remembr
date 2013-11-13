//
//  EditExistingCategoryViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-09-23.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "EditExistingCategoryViewController.h"

@interface EditExistingCategoryViewController ()

@end

@implementation EditExistingCategoryViewController

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
    // Do any additional setup after loading the view from its nib.
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector (textFieldTextChanged:)
                               name:UITextFieldTextDidChangeNotification
                             object:self.categoryTitleField];
    
    UIColor *backgroundLabels = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    self.view.backgroundColor = backgroundLabels;

    
    self.iconArray = [[NSArray alloc]initWithArray:[[collectionStore collectionStore]returnIconPack]];
    self.backgroundColorArray = [[NSArray alloc]initWithArray:[[collectionStore collectionStore]returnColors]];
    
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
    
    
    self.iconArray = [[NSArray alloc]initWithArray:[[collectionStore collectionStore]returnIconPack]];
    self.backgroundColorArray = [[NSArray alloc]initWithArray:[[collectionStore collectionStore]returnColors]];

    
    UINavigationItem *nav = [[UINavigationItem alloc]init];
    
    nav.title = self.categoryToBeEditied.title;
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveChangesToCatagory:)];
    
    [[self navigationItem] setRightBarButtonItem:save];
    
    self.categoryTitleField.text = self.categoryToBeEditied.title;
    [self.categoryTitleField setHidden:YES];
    [self.categoryTitleField becomeFirstResponder];
    
    
    //Select category assets
    UIImage *image = [UIImage imageNamed:self.categoryToBeEditied.imageName];
    int iIndex = [self.iconArray indexOfObject:image];
    [self.iconCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:iIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    int colourIndex = [self.backgroundColorArray indexOfObject:self.categoryToBeEditied.categoryColor];
    
    [self.backgroundCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:colourIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    [self.iconCollectionView reloadItemsAtIndexPaths:[self.iconCollectionView indexPathsForSelectedItems]];
    [self.backgroundCollectionView reloadItemsAtIndexPaths:[self.backgroundCollectionView indexPathsForSelectedItems]];
}

- (void) saveChangesToCatagory: (id)sender {
    
    self.categoryToBeEditied.title = self.categoryTitleField.text;
    if(self.editedImageName){
        self.categoryToBeEditied.imageName = self.editedImageName;
    }
    
    if(self.editedColor){
        self.categoryToBeEditied.categoryColor = self.editedColor;
    }
    
    [[CategoryStore categoryStore]saveChanges];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (void)textFieldTextChanged:(id)sender{
    self.navigationItem.title = self.categoryTitleField.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (Customcell.selected) {
            Customcell.alpha = 0.2f;
        } else {
            Customcell.alpha = 1.0f;
        }
        return Customcell;
    }else{
        collectionViewCellCustom *Customcell = (collectionViewCellCustom *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        Customcell.backgroundColor = [self.backgroundColorArray objectAtIndex:indexPath.row];
        if (Customcell.selected) {
            Customcell.alpha = 0.2f;
        } else {
            Customcell.alpha = 1.0f;
        }
        return Customcell;
        
    }
    

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.iconCollectionView){
        
        NSString *imageIndex = [NSString stringWithFormat:@"%d",indexPath.row];
        NSString *selectedImageName = [imageIndex stringByAppendingString:@".png"];
        self.editedImageName = selectedImageName;
        collectionViewCellCustom *cell = (collectionViewCellCustom *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundImage.clipsToBounds = YES;
        [cell setAlpha:0.5f];
        
    }else if(collectionView == self.backgroundCollectionView){
        
        UIColor *colorSelected = [self.backgroundColorArray objectAtIndex:indexPath.row];
        self.editedColor = colorSelected;
        collectionViewCellCustom *cell = (collectionViewCellCustom *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setAlpha:0.2f];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.navigationItem.title = self.categoryToBeEditied.title;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionViewCellCustom *cell = (collectionViewCellCustom *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setAlpha:1];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.categoryToBeEditied.title = self.categoryTitleField.text;
    if(self.editedImageName){
        self.categoryToBeEditied.imageName = self.editedImageName;
    }
    
    if(self.editedColor){
        self.categoryToBeEditied.categoryColor = self.editedColor;
    }
    
    [[CategoryStore categoryStore]saveChanges];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    return NO;
}

@end
