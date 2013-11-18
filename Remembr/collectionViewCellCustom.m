//
//  collectionViewCellCustom.m
//  Remembr
//
//  Created by Karan Thukral on 2013-10-05.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "collectionViewCellCustom.h"

@implementation collectionViewCellCustom

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"collectionViewCellCustom" owner:self options:nil];
        self = [nib objectAtIndex:0];    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
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
