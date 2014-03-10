//
//  ItemListViewController.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "ItemListViewController.h"
#import <BVReorderTableView.h>

@interface ItemListViewController ()

@property (strong, nonatomic) BVReorderTableView *itemListView;
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
    self.itemListView = [[BVReorderTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.itemListView.delegate = self;
    self.itemListView.dataSource = self;
    self.itemListView.separatorInset = UIEdgeInsetsZero;  
    [self.view addSubview:self.itemListView];
    
    //Notification set to check when the user changes the system text size from the settings application
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    //BVReorderTableView library used to implement tap and hold to reorder
    [super setEditing:editing animated:animated];
    ((BVReorderTableView *)self.itemListView).canReorder = editing;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //base row height to make transistions smother when text size and cell size is changed
    return 68;
}

- (void)setUpNavButtons:(id)sender{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Group copy.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editMode:)];
    
    NSArray *buttons = [NSArray arrayWithObjects:addButton,edit,nil];
    [[self navigationItem]setRightBarButtonItems:buttons];

}

- (void)noEditButton:(id)sender{
    //Only called if the category item array is empty
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    [[self navigationItem]setRightBarButtonItem:addButton];
}

- (void)preferredContentSizeChanged:(id)sender{
    //react to the change in text size
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
    //enter edit mode to delete or reorder the rows
    self.itemListView.editing = YES;
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    NSArray *buttons = [NSArray arrayWithObjects:addButton,done, nil];
    [self.navigationItem setRightBarButtonItems:buttons];
    
}

- (void)done:(id)sender{
    //to end editing mode
    self.itemListView.editing = NO;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Group copy.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editMode:)];
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
    
    if ([self.categorySelected.itemArray[indexPath.row] isKindOfClass:[NSString class]] && [self.categorySelected.itemArray[indexPath.row] isEqualToString:@"EMPTYROW"]) {
        UITableViewCell *emptyCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!emptyCell) {
            emptyCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eCell"];
        }
        emptyCell.textLabel.text = @"";
        emptyCell.contentView.backgroundColor = [UIColor clearColor];
        emptyCell.accessoryType = UITableViewCellAccessoryNone;
        return emptyCell;
    } //empty cell method used to conform to the BVReorderTableView library
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0]; //register nib for custom table view cell
    }
    
    Item *currentItem = [self.categorySelected.itemArray objectAtIndex:indexPath.row];
    Item *itemToAdd = [[Item alloc]initWithTitle:currentItem.itemTitle withImageKey:currentItem.imageKey withDescription:currentItem.itemDescription];
    
    NSLog(@"Index Path Row = %i",indexPath.row);
    
    cell.itemTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.itemTitle.numberOfLines = 0;
    
    [[cell itemTitle]setText:itemToAdd.itemTitle];
    cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.itemImage.clipsToBounds = YES;
    [[cell itemImage]setImage:[[ImageStore imageStore]imageForKey:itemToAdd.imageKey]]; //Image Store to retrieve saved images using the unique image key store in the item object
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemViewController *itemViewController = [[ItemViewController alloc]init];
    
    itemViewController.categorySelected = self.categorySelected;
    itemViewController.itemIndex = indexPath.row;
    
    [self.navigationController pushViewController:itemViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //dynamic type is used
    
    if ([self.categorySelected.itemArray[indexPath.row] isKindOfClass:[NSString class]] && [self.categorySelected.itemArray[indexPath.row] isEqualToString:@"EMPTYROW"]) {
        return 70;
    }
    
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
    //reordering table view cells
    Item *item = [self.categorySelected.itemArray objectAtIndex:sourceIndexPath.row];
    [self.categorySelected.itemArray removeObjectAtIndex:sourceIndexPath.row];
    [self.categorySelected.itemArray insertObject:item atIndex:destinationIndexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
        //In edit mode, does not show the - button to delete. Swipe to delete works.
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
    //Hide the image so the delete button does not overlap
    cell.itemImage.alpha = 0.0f;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //unhide the image
    cell.itemImage.alpha = 1.0f;
}

- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath {
    //Conforming to BVReorderTableView library
    Item *itemBeingMoved = [self.categorySelected.itemArray objectAtIndex:indexPath.row];
    [self.categorySelected.itemArray replaceObjectAtIndex:indexPath.row withObject:@"EMPTYROW"];
    
    return itemBeingMoved;
}

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //Conforming to BVReorderTableView library
    Item *item = self.categorySelected.itemArray[fromIndexPath.row];
    
    [self.categorySelected.itemArray removeObjectAtIndex:fromIndexPath.row];
    [self.categorySelected.itemArray insertObject:item atIndex:toIndexPath.row];
}

- (void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath{
    //Conforming to BVReorderTableView library
    [self.categorySelected.itemArray replaceObjectAtIndex:indexPath.row withObject:object];
    [[CategoryStore categoryStore]saveChanges];
}



@end
