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
    
    //navigation
    UINavigationItem *nav = [self navigationItem];
    nav.title = @"Remembr";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCategory:)];
    [[self navigationItem]setRightBarButtonItem:addButton];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCatagories:)];
    
    [[self navigationItem]setLeftBarButtonItem:edit];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //collection view
    CGRect mainScreen = [[UIScreen mainScreen]bounds];
    CGFloat requiredHeight = mainScreen.size.height - 64;
    CGRect collectionViewFrame = CGRectMake(0, 0, mainScreen.size.width, requiredHeight);
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:collectionViewFrame collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.layout.itemSize = CGSizeMake(160, 160);
    self.layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;

    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    [self.collectionView removeFromSuperview];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.collectionView performBatchUpdates:^{ //looking into this with the book
        [self.collectionView reloadData];
    //}completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editCatagories:(id)sender{
    
    self.editView = [[EditCategoriesViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.editView];
    [self presentModalViewController:nav animated:YES];
}


- (IBAction)addNewCategory:(id)sender{
    if(!self.addCategoryView){
        self.addCategoryView = [[AddCategoryViewController alloc]initWithNibName:@"AddCategoryViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.addCategoryView animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[CategoryStore categoryStore] allCatagories]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *catagoriesPulled = [[CategoryStore categoryStore]allCatagories];
    Category *categoryRequested = [catagoriesPulled objectAtIndex:[indexPath row]];
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    [cell setController:self];
    [[cell categoryTitle]setText:categoryRequested.title];
    [[cell categoryImageView]setImage:[UIImage imageNamed:@"logo.jpg"]];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /*NSArray *catagoriesPulled = [[CategoryStore categoryStore]allCatagories];
    Category *categoryRequested = [catagoriesPulled objectAtIndex:[indexPath row]];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Category Selected" message:categoryRequested.title delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:nil];
    [alert show];*/
    
    Category *categoryClicked = [[[CategoryStore categoryStore]allCatagories]objectAtIndex:indexPath.row];
    self.itemListView = [[ItemListViewController alloc]init];
    self.itemListView.categorySelected = categoryClicked;
    [self.navigationController pushViewController:self.itemListView animated:YES];
}



@end
