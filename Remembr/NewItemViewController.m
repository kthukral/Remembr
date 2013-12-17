//
//  NewItemViewController.m
//  Remembr
//
//  Created by Karan Thukral on 10/24/2013.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "NewItemViewController.h"
#import <MWPhotoBrowser.h>

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
    
    UIMenuItem *strikethrough = [[UIMenuItem alloc]initWithTitle:@"Strike" action:@selector(strikeTheSelection:)];
    
    //UIMenuItem *unStrike = [[UIMenuItem alloc]initWithTitle:@"Un-Strike" action:@selector(unstrikeSelection:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:strikethrough, nil]];
    
    self.photoArray = [NSMutableArray new];
    
    [self layoutSubviews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];

    
}

- (void)preferredContentSizeChanged:(id)sender{
    [self viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    Item *itemToDisplay = [self.categorySelected.itemArray objectAtIndex:self.itemIndex];
    itemToDisplay.attrDescription = self.descriptionTextView.attributedText;
    
    [[CategoryStore categoryStore]saveChanges];
}

- (void)layoutSubviews{
    
    Item *itemToDisplay = [self.categorySelected.itemArray objectAtIndex:self.itemIndex];
    
    self.navigationItem.title = itemToDisplay.itemTitle;
    
    if(itemToDisplay.hasImage){
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.button = [[UIButton alloc]initWithFrame:self.imageView.frame];
        [self.button addTarget:self action:@selector(openFullImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button];
        self.imageView.image = [[ImageStore imageStore]imageForKey:itemToDisplay.imageKey];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        
    } else {
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    
    self.titleLabel = [UILabel new];
    
    [self.titleLabel setFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height, 320, 45)];
    
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.titleLabel.text = itemToDisplay.itemTitle;
    self.titleLabel.textColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
  
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, self.titleLabel.frame.origin.y + 50, 310, self.view.frame.size.height - 5 - self.imageView.frame.size.height - 45)];
    
    self.descriptionTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.scrollEnabled = YES;
    self.descriptionTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //NSAttributedString *attr = [[NSAttributedString alloc]initWithString:itemToDisplay.itemDescription attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    //[self.descriptionTextView setText:itemToDisplay.itemDescription];
    //[self.descriptionTextView setAttributedText:attr];
    [self.descriptionTextView setAttributedText:itemToDisplay.attrDescription];
    
    UIColor *background = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];;
    self.view.backgroundColor = background;
    
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0.38f green:0.37f blue:0.38f alpha:0.8f];
    
    self.descriptionTextView.backgroundColor = background;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [[self navigationItem]setRightBarButtonItem:edit];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descriptionTextView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.imageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.descriptionTextView removeFromSuperview];
    [self.button removeFromSuperview];
    [self viewDidLoad];
}

- (void)openFullImage:(id)sender{
    
    Item *item = [self.categorySelected.itemArray objectAtIndex:self.itemIndex];
    
    UIImage *itemImage = [[ImageStore imageStore]imageForKey:item.imageKey];
    
    MWPhoto *photo = [[MWPhoto alloc]initWithImage:itemImage];
    
    [self.photoArray addObject:photo];
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    photoBrowser.displayActionButton = YES;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.zoomPhotosToFill = YES;
    [photoBrowser setCurrentPhotoIndex:1];
    //photoBrowser.wantsFullScreenLayout = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photoBrowser];
    //[self.navigationController pushViewController:photoBrowser animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
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

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photoArray.count)
        return [self.photoArray objectAtIndex:index];
    return nil;
}

- (void)strikeTheSelection:(id)sender {
    
    Item *item = self.categorySelected.itemArray[self.itemIndex];
    
    for (int i = 0; i<item.rangesForStrike.count; i++) {
        NSRange range = [[item.rangesForStrike objectAtIndex:i] rangeValue];
        if (NSEqualRanges(range, self.descriptionTextView.selectedRange)) {
            [item.rangesForStrike removeObjectAtIndex:i];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
            
            attrStr = (NSMutableAttributedString *)self.descriptionTextView.attributedText;
            
            NSDictionary* strikeThroughAttributes = [NSDictionary new]; //FIGURE OUT HOW TO REMOVE ATTR
            
            [attrStr removeAttribute:NSStrikethroughStyleAttributeName range:self.descriptionTextView.selectedRange];
            
            strikeThroughAttributes = @{NSStrikethroughStyleAttributeName : @0,NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSStrikethroughColorAttributeName:[UIColor redColor]};
            
            [attrStr setAttributes:strikeThroughAttributes range:self.descriptionTextView.selectedRange];
            
            self.descriptionTextView.text = @"";
            self.descriptionTextView.attributedText = attrStr;
            
            return;

        }
    }
    
    [item.rangesForStrike addObject:[NSValue valueWithRange:self.descriptionTextView.selectedRange]];
    
    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
    
    attrStr = (NSMutableAttributedString *)self.descriptionTextView.attributedText;
    
    NSDictionary* strikeThroughAttributes = [NSDictionary new]; //FIGURE OUT HOW TO REMOVE ATTR
    
    [attrStr removeAttribute:NSStrikethroughStyleAttributeName range:self.descriptionTextView.selectedRange];
    
    strikeThroughAttributes = @{NSStrikethroughStyleAttributeName : @1,NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSStrikethroughColorAttributeName:[UIColor redColor]};
    
    [attrStr setAttributes:strikeThroughAttributes range:self.descriptionTextView.selectedRange];
    
    self.descriptionTextView.text = @"";
    self.descriptionTextView.attributedText = attrStr;
    
}

// in TESTING

//- (void)unstrikeSelection:(id)sender {
//    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
//    
//    attrStr = (NSMutableAttributedString *)self.descriptionTextView.attributedText;
//    
//    NSDictionary* strikeThroughAttributes = [NSDictionary new]; //FIGURE OUT HOW TO REMOVE ATTR
//    
//    [attrStr removeAttribute:NSStrikethroughStyleAttributeName range:self.descriptionTextView.selectedRange];
//    
//    strikeThroughAttributes = @{NSStrikethroughStyleAttributeName : @0,NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSStrikethroughColorAttributeName:[UIColor redColor]};
//    
//    [attrStr setAttributes:strikeThroughAttributes range:self.descriptionTextView.selectedRange];
//    
//    self.descriptionTextView.text = @"";
//    self.descriptionTextView.attributedText = attrStr;
//
//}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(strikeTheSelection:)) {
        if (self.descriptionTextView.selectedRange.length > 0) {
            return YES;
        }
    }
    return NO;
}

@end
