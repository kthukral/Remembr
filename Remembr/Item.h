//
//  Item.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCoding>

@property (strong, nonatomic) NSString *itemTitle;
@property (strong, nonatomic) NSString *imageKey;
@property (strong, nonatomic) NSString *itemDescription;

- (id)initWithTitle:(NSString *)title withImageKey:(NSString *)key withDescription:(NSString *)description;

- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description;

@end
