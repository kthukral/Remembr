//
//  CustomCollectionViewCell.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.categoryTitle.text = @"";
    self.backgroundColor = [UIColor blackColor];
    self.categoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:nil]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
