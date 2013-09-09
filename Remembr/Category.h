//
//  Category.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject <NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) UIImage *categoryImage;
@property (strong, nonatomic) NSMutableArray *itemArray;

- (id)initWithTitle:(NSString *)title withImage:(UIImage *)categoryImage;
- (id)initWithTitle:(NSString *)title;

@end
