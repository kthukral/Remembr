//
//  CategoryStore.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "CategoryStore.h"

@implementation CategoryStore


- (id)init
{
    self = [super init];
    
    if (self) {
        
        NSString *path = [self itemArchievePath];
        
        allCatagories = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allCatagories) {
            allCatagories = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

+ (CategoryStore *)categoryStore{
    
    static CategoryStore * categorystore = nil;
    if (!categorystore) {
        categorystore = [[super allocWithZone:nil] init];
    }
    
    return categorystore;

}
- (NSArray *)allCatagories{
    
    return allCatagories;
    
}

- (Category *)createCategoryWithTitle:(NSString *)title{
    
    Category *newCategory = [[Category alloc]initWithTitle:title];
    [allCatagories addObject:newCategory];
    return newCategory;
}

- (NSString *)itemArchievePath{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"category.archive"];
    
}

- (BOOL)saveChanges{
    NSString *path = [self itemArchievePath];
    
    return [NSKeyedArchiver archiveRootObject:allCatagories
                                       toFile:path];
}

- (void)updateCategoryArray:(NSMutableArray *)newArray{
    allCatagories = [[NSMutableArray alloc]initWithArray:newArray];
}

- (Category *)createCategoryWithTitle:(NSString *)title withColor:(UIColor *)color andImageName:(NSString *)iName{
    
    
    BOOL doesCategoryExist = NO;
    for (int i=0; i<[allCatagories count]; i++){
        Category *checkCategory = [allCatagories objectAtIndex:i];
        NSString *checkCategoryTitle = checkCategory.title;
        if([title isEqualToString:checkCategoryTitle]){
            doesCategoryExist = YES;
        }
        
    }
    
    if (doesCategoryExist){
        UIAlertView *existingCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Category Already Exists" message:@"This Category Already Exists. Please use a different title." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [existingCategoryAlert show];
        
        return nil;
        
    } else {
        
        Category *newCategory = [[Category alloc]initWithTitle:title withColor:color withImageName:iName];
        [allCatagories insertObject:newCategory atIndex:0];
        [[CategoryStore categoryStore] saveChanges];
        return newCategory;
        
    }

}

- (Category *)createCategoryWithTitle:(NSString *)title withColor:(UIColor *)color andImageName:(NSString *)iName withIndex:(int)index{
    
    
    BOOL doesCategoryExist = NO;
    for (int i=0;i<[allCatagories count];i++){
        Category *checkCategory = [allCatagories objectAtIndex:i];
        NSString *checkCategoryTitle = checkCategory.title;
        if([title isEqualToString:checkCategoryTitle]){
            doesCategoryExist = YES;
        }
        
    }
    
    if (doesCategoryExist){
        UIAlertView *existingCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Category Already Exists" message:@"This Category Already Exists. Please use a different title." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [existingCategoryAlert show];
        
        return nil;
        
    } else {
        
        Category *newCategory = [[Category alloc]initWithTitle:title withColor:color withImageName:iName withIndex:index];
        [allCatagories insertObject:newCategory atIndex:0];
        [[CategoryStore categoryStore] saveChanges];
        return newCategory;
        
    }
    
}

- (void)addNewCategory:(Category *)category{
    [allCatagories insertObject:category atIndex:0];
}



@end
