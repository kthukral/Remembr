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

- (Category *)createCategoryWithTitle:(NSString *)newtitle withImage:(UIImage *)image{
    
    BOOL doesCategoryExist = NO;
    for(int i=0;i<[allCatagories count];i++){
        Category *checkCategory = [allCatagories objectAtIndex:i];
        NSString *checkCategoryTitle = checkCategory.title;
        if([newtitle isEqualToString:checkCategoryTitle]){
            doesCategoryExist = YES;
        }
        
    }
    if(doesCategoryExist){
        UIAlertView *existingCategoryAlert = [[UIAlertView alloc]initWithTitle:@"Category Already Exists" message:@"This Category Already Exists. Please use a different title." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [existingCategoryAlert show];
        
        return nil;
    }else{
    Category *newCategory = [[Category alloc]initWithTitle:newtitle withImage:image];
    
    //[allCatagories addObject:newCategory];
    [allCatagories insertObject:newCategory atIndex:0];
    return newCategory;
    }
    
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
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"categories.archive"];
    
}

- (BOOL)saveChanges{
    NSString *path = [self itemArchievePath];
    return [NSKeyedArchiver archiveRootObject:allCatagories toFile:path];
}

@end
