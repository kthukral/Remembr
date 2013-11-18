//
//  CustomCollectionViewCell.h
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (nonatomic, weak) id controller;
@end
