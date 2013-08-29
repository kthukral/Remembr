//
//  Category.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id)initWithTitle:(NSString *)title withImage:(UIImage *)categoryImage{
    self = [super init];
    if(self){
        [self setTitle:title];
        [self setCategoryImage:categoryImage];
        self.itemArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title{
    self = [super init];
    if(self){
        [self setTitle:title];
        self.itemArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
