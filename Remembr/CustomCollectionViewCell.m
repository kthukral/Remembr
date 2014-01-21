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
        [self setNeedsDisplay];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.categoryTitle.text = @"";
    self.backgroundColor = [UIColor blackColor];
    self.categoryImageView = nil;
}

@end
