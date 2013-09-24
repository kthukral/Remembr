//
//  Item.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithTitle:(NSString *)title withImage:(UIImage *)image withDescription:(NSString *)description{
    self = [super init];
    
    if(self){
        [self setItemTitle:title];
        [self setItemImage:image];
        [self setItemDescription:description];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        
        NSData *imageData = [aDecoder decodeObjectForKey:@"imageData"];
        UIImage *decodedImage = [[UIImage alloc]initWithData:imageData];
        self.itemImage = decodedImage;
        
        self.itemDescription = [aDecoder decodeObjectForKey:@"itemDescription"];
        self.itemTitle = [aDecoder decodeObjectForKey:@"itemTitle"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSData *imageData = UIImagePNGRepresentation(self.itemImage);
    [aCoder encodeObject:imageData forKey:@"imageData"];
    [aCoder encodeObject:self.itemDescription forKey:@"itemDescription"];
    [aCoder encodeObject:self.itemTitle forKey:@"itemTitle"];
}

@end
