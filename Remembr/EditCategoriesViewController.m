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
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode:)];
    
    [[self navigationItem]setRightBarButtonItem:saveButton];

    [[self navigationItem] setLeftBarButtonItem:edit];
    
    self.editCategoryTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.editCategoryTableView.delegate = self;
    self.editCategoryTableView.dataSource = self;
    self.editCategoryTableView.separatorInset = UIEdgeInsetsZero;
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

- (void)editMode:(id)sender{
    self.editCategoryTableView.editing = YES;
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [self.navigationItem setLeftBarButtonItem:done];

}

- (void)done:(id)sender{
    
    self.editCategoryTableView.editing = NO;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode:)];
    
    [self.navigationItem setLeftBarButtonItem:edit];

    
}

- (void)cancel:(id)sender{
    
    if(!self.editCategoryTableView.editing){
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self done:sender];
    }
    
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
    cell.showsReorderControl = YES;
    [[cell itemTitle]setText:current.title];
    cell.backgroundColor = current.categoryColor;
    cell.itemImage.image = [UIImage imageNamed:current.imageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Category *category = [self.editCategories objectAtIndex:sourceIndexPath.row];
    [self.editCategories removeObjectAtIndex:sourceIndexPath.row];
    [self.editCategories insertObject:category atIndex:destinationIndexPath.row];
}
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editCategoryTableView.editing){
        return UITableViewCellEditingStyleNone;
    }else{
    return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.editCategories removeObjectAtIndex:indexPath.row];
        [self.editCategoryTableView beginUpdates];
        NSArray *indexArray = [[NSArray alloc]initWithObjects:indexPath, nil];
        [self.editCategoryTableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationLeft];
        [self.editCategoryTableView endUpdates];
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

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.itemImage.alpha = 0;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.itemImage.alpha = 1;
}

@end
