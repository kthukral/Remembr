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

@end
