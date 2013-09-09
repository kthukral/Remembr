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

- (void)
encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.categoryImage forKey:@"categoryImage"];
    [aCoder encodeObject:self.itemArray forKey:@"itemArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setCategoryImage:[aDecoder decodeObjectForKey:@"categoryImage"]];
        [self setItemArray:[aDecoder decodeObjectForKey:@"itemArray"]];
    }
    
    return self;
}
@end
