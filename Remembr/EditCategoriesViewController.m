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
    
    NSArray *temp = [[CategoryStore categoryStore]allCatagories];
    
    self.editCategories = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:temp]];
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

- (void)viewWillAppear:(BOOL)animated{
    [self.editCategoryTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveEditChanges:(id)sender{
    
    [[CategoryStore categoryStore]updateCategoryArray:self.editCategories];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [[cell itemTitle]setText:current.title];
    cell.backgroundColor = current.categoryColor;
    cell.itemImage.image = [UIImage imageNamed:current.imageName];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditExistingCategoryViewController *editView = [[EditExistingCategoryViewController alloc]initWithNibName:@"EditExistingCategoryViewController" bundle:nil];
    editView.categoryToBeEditied = [self.editCategories objectAtIndex:indexPath.row];
    editView.index = indexPath.row;
    [self.navigationController pushViewController:editView animated:YES];
    
}

@end
