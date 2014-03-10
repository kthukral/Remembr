//
//  CategoryViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) AddCategoryViewController *addCategoryView;
@property (strong, nonatomic) ItemListViewController *itemListView;
@property (strong, nonatomic) EditCategoriesViewController *editView;

@end

@implementation CategoryViewController



- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.categories = (NSMutableArray *)[[CategoryStore categoryStore]allCatagories];
    
    //navigation setup
    UINavigationItem *nav = [self navigationItem];
    nav.title = @"Remembr";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCategory:)];
    [[self navigationItem]setRightBarButtonItem:addButton];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCatagories:)];
    
    [[self navigationItem]setLeftBarButtonItem:edit];
    
    //navigationController and bar appearence setup
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29f green:0.61f blue:0.85f alpha:1.00f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance]setTitleTextAttributes:textTitleOptions];

    
    //collection view setup (the cells need to be end to end and 2 cells occupy one row for the collecion view)
    CGRect mainScreen = [[UIScreen mainScreen]bounds];
    CGFloat requiredHeight = mainScreen.size.height;
    CGRect collectionViewFrame = CGRectMake(0, 0, mainScreen.size.width, requiredHeight);
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    
    self.layout = [[LXReorderableCollectionViewFlowLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:collectionViewFrame collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.layout.itemSize = CGSizeMake(160, 160); //only 2 cells fit in a row
    self.layout.sectionInset = UIEdgeInsetsMake(0,0,0,0); //no spacing between the cells
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;

    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"]; //register custom collection view cell with its class
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    
}

- (void)viewWillAppear:(BOOL)animated{
    //reload data incase new category created or deleated
    [self.collectionView reloadData];
    self.categories = (NSMutableArray *)[[CategoryStore categoryStore]allCatagories];
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editCatagories:(id)sender{
    //edit view presents catagories in a table view and can be edited
    self.editView = [[EditCategoriesViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.editView];
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)addNewCategory:(id)sender{
    //launch new category view controller
    if(!self.addCategoryView){
        self.addCategoryView = [[AddCategoryViewController alloc]initWithNibName:@"AddCategoryViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.addCategoryView animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //Category Store is resonsible for handling, creating, deleting and saving catagories
    return [[[CategoryStore categoryStore] allCatagories]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *catagoriesPulled = [[CategoryStore categoryStore]allCatagories]; //Array of all stored catagories
    Category *categoryRequested = [catagoriesPulled objectAtIndex:[indexPath row]];
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    cell.categoryTitle.numberOfLines = 1;
    cell.categoryTitle.adjustsFontSizeToFitWidth = YES;
    [[cell categoryTitle]setText:categoryRequested.title];
    
    //the view is added as a background view to ensure the image is displayed clearly in the image view
    UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
    [imageView setFrame:CGRectMake(64, 64, 32, 32)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:categoryRequested.imageName];
    [view addSubview:imageView];
    [cell setBackgroundView:view];
    
    cell.backgroundColor = categoryRequested.categoryColor;
    
    //Debug log
    NSLog(@"%@,%@",categoryRequested.title, categoryRequested.imageName);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //each category object has an aray of item objects that are its "children"
    Category *categoryClicked = [[[CategoryStore categoryStore]allCatagories]objectAtIndex:indexPath.row];
    self.itemListView = [[ItemListViewController alloc]init];
    self.itemListView.categorySelected = categoryClicked;
    [self.navigationController pushViewController:self.itemListView animated:YES];
    
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    //LXReorderableCollectionViewFlowLayout library method implementation to change the order of the catagories
    Category *category = [[CategoryStore categoryStore]allCatagories][fromIndexPath.row];
    [((NSMutableArray *)[[CategoryStore categoryStore]allCatagories]) removeObjectAtIndex:fromIndexPath.row];
    [((NSMutableArray *)[[CategoryStore categoryStore]allCatagories]) insertObject:category atIndex:toIndexPath.row];
    
    //Category store is responsible for storing the changes to the local disc
    [[CategoryStore categoryStore]saveChanges];
}


@end
