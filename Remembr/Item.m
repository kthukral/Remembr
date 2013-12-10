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
        [self setAttrDescription:[[NSAttributedString alloc] initWithString:description]];
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
        [self setAttrDescription:[[NSAttributedString alloc] initWithString:description]];
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
        self.attrDescription = [aDecoder decodeObjectForKey:@"attrDescription"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
    [aCoder encodeObject:self.itemDescription forKey:@"itemDescription"];
    [aCoder encodeObject:self.itemTitle forKey:@"itemTitle"];
    [aCoder encodeBool:self.hasImage forKey:@"hasImage"];
    [aCoder encodeObject:self.attrDescription forKey:@"attrDescription"];
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
