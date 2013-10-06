//
//  Category.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "Category.h"

@implementation Category

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
    [aCoder encodeObject:self.categoryColor forKey:@"color"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.itemArray forKey:@"itemArray"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setImageName:[aDecoder decodeObjectForKey:@"imageName"]];
        [self setCategoryColor:[aDecoder decodeObjectForKey:@"color"]];
        [self setItemArray:[aDecoder decodeObjectForKey:@"itemArray"]];
    }
    
    return self;
}

- (Class)classForCoder{
    return [self class];
}

- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withImageName:(NSString *)iName{
    self = [super init];
    if(self){
        [self setTitle:title];
        self.itemArray = [[NSMutableArray alloc]init];
        [self setCategoryColor:color];
        [self setImageName:iName];
    }
    return self;
}
@end
