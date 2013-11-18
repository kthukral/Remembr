//
//  Item.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithTitle:(NSString *)title withImageKey:(NSString *)key withDescription:(NSString *)description{
    self = [super init];
    
    if(self){
        [self setItemTitle:title];
        [self setImageKey:key];
        [self setItemDescription:description];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title withImageKey:(NSString *)key withDescription:(NSString *)description hasImage:(BOOL)hasImage{
    self = [super init];
    
    if(self){
        [self setItemTitle:title];
        [self setImageKey:key];
        [self setItemDescription:description];
        [self setHasImage:hasImage];
    }
    
    return self;

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        
        self.imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        
        self.itemDescription = [aDecoder decodeObjectForKey:@"itemDescription"];
        self.itemTitle = [aDecoder decodeObjectForKey:@"itemTitle"];
        self.hasImage = [aDecoder decodeBoolForKey:@"hasImage"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
    [aCoder encodeObject:self.itemDescription forKey:@"itemDescription"];
    [aCoder encodeObject:self.itemTitle forKey:@"itemTitle"];
    [aCoder encodeBool:self.hasImage forKey:@"hasImage"];
}

- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description{
    self = [super init];
    
    if(self){
        [self setItemTitle:title];
        [self setItemDescription:description];
    }
    
    return self;
}

@end
