//
//  EditCategoriesViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-09-22.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "EditCategoriesViewController.h"

@interface EditCategoriesViewController ()

@property (strong, nonatomic) UITableView *editCategoryTableView;
@property (strong, nonatomic) NSMutableArray *editCategories;

@end

@implementation EditCategoriesViewController

- (id)init{
    self = [super init];
    if(self){}
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.editCategories = [[NSMutableArray alloc]initWithArray:[[CategoryStore categoryStore]allCatagories]];
    UINavigationItem *nav = [self navigationItem];
    
    nav.title = @"Edit Categories";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveEditChanges:)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    [[self navigationItem]setRightBarButtonItem:saveButton];
    [[self navigationItem] setLeftBarButtonItem:cancel];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.editCategoryTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.editCategoryTableView.delegate = self;
    self.editCategoryTableView.dataSource = self;
    [self.view addSubview:self.editCategoryTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveEditChanges:(id)sender{
    
    [[CategoryStore categoryStore]updateCategoryArray:self.editCategories];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)cancel:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.editCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Index = %d",indexPath.row);
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Category *current = [self.editCategories objectAtIndex:indexPath.row];
    
    [[cell itemTitle]setText:current.title];
    [[cell itemImage]setImage:current.categoryImage];
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.editCategories removeObjectAtIndex:indexPath.row];
        [self.editCategoryTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

@end
