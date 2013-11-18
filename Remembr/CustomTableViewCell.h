//
//  CustomTableViewCell.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-29.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@end
