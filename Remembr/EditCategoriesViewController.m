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
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Group copy.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editMode:)];
    
    [[self navigationItem]setRightBarButtonItem:saveButton];

    [[self navigationItem] setLeftBarButtonItem:edit];
    
    self.editCategoryTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29f green:0.61f blue:0.85f alpha:1.00f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    self.editCategoryTableView.delegate = self;
    self.editCategoryTableView.dataSource = self;
    self.editCategoryTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.editCategoryTableView];
    [self.editCategoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];

}

- (void)preferredContentSizeChanged:(id)sender{
    [self.editCategoryTableView reloadData];
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
    [[CategoryStore categoryStore]saveChanges];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)editMode:(id)sender{
    self.editCategoryTableView.editing = YES;
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [self.navigationItem setLeftBarButtonItem:done];

}

- (void)done:(id)sender{
    
    self.editCategoryTableView.editing = NO;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Group copy.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editMode:)];
    
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
    editCategoryTableViewCell *cell = (editCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"editCategoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (!self.editCategoryTableView.editing) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Category *current = [self.editCategories objectAtIndex:indexPath.row];
    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    cell.showsReorderControl = YES;
    [[cell title]setText:current.title];
    cell.backgroundColor = current.categoryColor;
    cell.image.image = [UIImage imageNamed:current.imageName];
    
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
    Category *category = [self.editCategories objectAtIndex:indexPath.row];
    
    UIFont *titleLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    CGRect titleLabelFontSize = [category.title boundingRectWithSize:CGSizeMake(193, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:titleLabelFont forKey:NSFontAttributeName] context:nil];
    
    CGFloat PADDING_OUTER = 15;
    
    CGFloat totalHeight = PADDING_OUTER + titleLabelFontSize.size.height + 15 + PADDING_OUTER;
    
    return totalHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditExistingCategoryViewController *editView = [[EditExistingCategoryViewController alloc]initWithNibName:@"EditExistingCategoryViewController" bundle:nil];
    editView.categoryToBeEditied = [self.editCategories objectAtIndex:indexPath.row];
    editView.index = indexPath.row;
    [self.navigationController pushViewController:editView animated:YES];
    
}



- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    editCategoryTableViewCell *cell = (editCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.image.alpha = 0;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    editCategoryTableViewCell *cell = (editCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.image.alpha = 1;
}


@end
