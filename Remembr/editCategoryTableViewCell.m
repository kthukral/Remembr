//
//  editCategoryTableViewCell.m
//  Remembr
//
//  Created by Karan Thukral on 11/17/2013.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "editCategoryTableViewCell.h"

@implementation editCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing{
    self.image.alpha = 0.0f;
}

@end
