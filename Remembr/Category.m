//
//  Category.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "Category.h"
#import "ImageStore.h"

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
    
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
    
    [aCoder encodeObject:self.itemArray forKey:@"itemArray"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        
        [self setItemArray:[aDecoder decodeObjectForKey:@"itemArray"]];
        
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
    }
    
    return self;
}

- (Class)classForCoder{
    return [self class];
}
@end
