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
@property (strong, nonatomic) ItemViewController *itemView;
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
    nav.title = @"Remembr";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
    [[self navigationItem]setRightBarButtonItem:addButton];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    self.itemListView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.itemListView.delegate = self;
    self.itemListView.dataSource = self;
    [self.view addSubview:self.itemListView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self.itemListView reloadData];
    NSLog(@"%@",self.categorySelected.title);
    for(int i = 0; i<[self.categorySelected.itemArray count];i++){
        Item *item = [self.categorySelected.itemArray objectAtIndex:i];
        NSLog(@"Item = %@",item.itemTitle);
        ;    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.itemListView.rowHeight = 68;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addNewItem:(id)sender{
    if(!self.addNewItemView){
        self.addNewItemView = [[AddItemViewController alloc]initWithNibName:@"AddItemViewController" bundle:nil];
    }
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
    Item *itemToAdd = [[Item alloc]initWithTitle:currentItem.itemTitle withImage:currentItem.itemImage withDescription:currentItem.itemDescription];
    
    NSLog(@"Index Path Row = %i",indexPath.row);
    
    [[cell itemTitle]setText:itemToAdd.itemTitle];
    [[cell itemImage]setImage:itemToAdd.itemImage];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.itemView = [[ItemViewController alloc]initWithNibName:@"ItemViewController" bundle:nil];
    self.itemView.itemToPopulate = [self.categorySelected.itemArray objectAtIndex:indexPath.row];
    self.itemView.parentCategory = self.categorySelected;
    self.itemView.indexSelected = indexPath.row;
    [self.navigationController pushViewController:self.itemView animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[ItemStore itemStore]deleteItemAtIndex:indexPath.row withCategory:self.categorySelected];
        [self.itemListView reloadData];
    }
    
}

@end
