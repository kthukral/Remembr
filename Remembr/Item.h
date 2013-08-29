//
//  Item.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-27.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *itemTitle;
@property (strong, nonatomic) UIImage *itemImage;
@property (strong, nonatomic) NSString *itemDescription;

- (id)initWithTitle:(NSString *)title withImage:(UIImage *)image withDescription:(NSString *)description;

@end
