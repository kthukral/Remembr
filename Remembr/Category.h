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
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) UIColor *categoryColor;
@property (strong, nonatomic) NSString *imageName;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withImageName:(NSString *)iName;

@end