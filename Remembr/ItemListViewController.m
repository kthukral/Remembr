//
//  ItemListViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "ItemListViewController.h"

@interface ItemListViewController ()

@property (strong, nonatomic) UITableView *itemListView;
@property (strong, nonatomic) AddItemViewController *addNewItemView;
@end

@implementation ItemListViewController

- (id)init{
    self = [super init];
    if(self){}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //navigation bar
    UINavigationItem *nav = [self navigationItem];
    nav.title = self.categorySelected.title;
    
    if (self.categorySelected.itemArray.count) {
        [self setUpNavButtons:self];
    } else {
        [self noEditButton:self];
    }
    self.itemListView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.itemListView.delegate = self;
    self.itemListView.dataSource = self;
    self.itemListView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.itemListView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}

- (void)setUpNavButtons:(id)sender{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode:)];
    NSArray *buttons = [NSArray arrayWithObjects:addButton,edit,nil];
    [[self navigationItem]setRightBarButtonItems:buttons];

}

- (void)noEditButton:(id)sender{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    [[self navigationItem]setRightBarButtonItem:addButton];
}

- (void)preferredContentSizeChanged:(id)sender{
    [self.itemListView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.categorySelected.itemArray.count) {
        [self setUpNavButtons:self];
    } else {
        [self noEditButton:self];
    }
    [self.itemListView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    if (self.itemListView.editing){
        self.itemListView.editing = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editMode:(id)sender{
    self.itemListView.editing = YES;
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    NSArray *buttons = [NSArray arrayWithObjects:addButton,done, nil];
    [self.navigationItem setRightBarButtonItems:buttons];
    
}

- (void)done:(id)sender{
    self.itemListView.editing = NO;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode:)];
    NSArray *buttons = [NSArray arrayWithObjects:addButton,edit,nil];
    [[self navigationItem]setRightBarButtonItems:buttons];
    
    
}

-(void)addNewItem:(id)sender{
    
    if (self.itemListView.editing){
        self.itemListView.editing = NO;
    }
    
    self.addNewItemView = [[AddItemViewController alloc]initWithNibName:@"AddItemViewController" bundle:nil];
    
    self.addNewItemView.category = self.categorySelected;
    
    [self.navigationController pushViewController:self.addNewItemView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categorySelected.itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Item *currentItem = [self.categorySelected.itemArray objectAtIndex:indexPath.row];
    Item *itemToAdd = [[Item alloc]initWithTitle:currentItem.itemTitle withImageKey:currentItem.imageKey withDescription:currentItem.itemDescription];
    
    NSLog(@"Index Path Row = %i",indexPath.row);
    
    cell.itemTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.itemTitle.numberOfLines = 0;
    
    [[cell itemTitle]setText:itemToAdd.itemTitle];
    cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.itemImage.clipsToBounds = YES;
    [[cell itemImage]setImage:[[ImageStore imageStore]imageForKey:itemToAdd.imageKey]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewItemViewController *newItemController = [[NewItemViewController alloc]init];
    
    newItemController.categorySelected = self.categorySelected;
    newItemController.itemIndex = indexPath.row;
    
    [self.navigationController pushViewController:newItemController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 68;
    
    Item *item = [self.categorySelected.itemArray objectAtIndex:indexPath.row];
    
    UIFont *titleLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    CGRect titleLabelFontSize = [item.itemTitle boundingRectWithSize:CGSizeMake(193, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:titleLabelFont forKey:NSFontAttributeName] context:nil];
    
    CGFloat PADDING_OUTER = 15;
    
    CGFloat totalHeight = PADDING_OUTER + titleLabelFontSize.size.height + 15 + PADDING_OUTER;
    
    return totalHeight;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[ItemStore itemStore]deleteItemAtIndex:indexPath.row withCategory:self.categorySelected];
        [self.itemListView beginUpdates];
        NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
        [self.itemListView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationLeft];
        [self.itemListView endUpdates];
    }
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    Item *item = [self.categorySelected.itemArray objectAtIndex:sourceIndexPath.row];
    [self.categorySelected.itemArray removeObjectAtIndex:sourceIndexPath.row];
    [self.categorySelected.itemArray insertObject:item atIndex:destinationIndexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemListView.editing){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.itemImage.alpha = 0.0f;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.itemImage.alpha = 1.0f;
}

@end
