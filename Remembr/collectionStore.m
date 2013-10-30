//
//  collectionStore.m
//  Remembr
//
//  Created by Karan Thukral on 2013-10-05.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "collectionStore.h"

@implementation collectionStore

- (id)init
{
    self = [super init];
    
    if (self) {
        
        }
    
    return self;
}

+ (collectionStore *)collectionStore{
    
    static collectionStore * collectionStore = nil;
    if (!collectionStore) {
        collectionStore = [[super allocWithZone:nil] init];
    }
    
    return collectionStore;
    
}


- (NSArray *)returnIconPack{
    NSMutableArray *iconParse = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < 107;i++){
            
        NSString *imageNumber = [NSString stringWithFormat:@"%d",i];
        NSString *imageName = [imageNumber stringByAppendingString:@".png"];
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        [iconParse insertObject:image atIndex:i];

    }
    
    NSArray *imageArray = [[NSArray alloc]initWithArray:iconParse];
    return imageArray;
}

- (NSArray *)returnColors{
    
    UIColor *color1 = [UIColor colorWithRed:0.10f green:0.74f blue:0.61f alpha:1.00f];
    UIColor *color2 = [UIColor colorWithRed:0.38f green:0.80f blue:0.44f alpha:1.00f];
    UIColor *color3 = [UIColor colorWithRed:0.21f green:0.60f blue:0.86f alpha:1.00f];
    UIColor *color4 = [UIColor colorWithRed:0.68f green:0.48f blue:0.77f alpha:1.00f];
    UIColor *color5 = [UIColor colorWithRed:0.20f green:0.29f blue:0.37f alpha:1.00f];
    UIColor *color6 = [UIColor colorWithRed:0.28f green:0.63f blue:0.53f alpha:1.00f];
    UIColor *color7 = [UIColor colorWithRed:0.32f green:0.69f blue:0.38f alpha:1.00f];
    UIColor *color8 = [UIColor colorWithRed:0.16f green:0.50f blue:0.72f alpha:1.00f];
    UIColor *color9 = [UIColor colorWithRed:0.55f green:0.27f blue:0.68f alpha:1.00f];
    UIColor *color10 = [UIColor colorWithRed:0.18f green:0.24f blue:0.31f alpha:1.00f];
    UIColor *color11 = [UIColor colorWithRed:0.95f green:0.77f blue:0.19f alpha:1.00f];
    UIColor *color12 = [UIColor colorWithRed:0.92f green:0.59f blue:0.31f alpha:1.00f];
    UIColor *color13 = [UIColor colorWithRed:0.91f green:0.30f blue:0.24f alpha:1.00f];
    UIColor *color14 = [UIColor colorWithRed:0.93f green:0.94f blue:0.95f alpha:1.00f];
    UIColor *color15 = [UIColor colorWithRed:0.58f green:0.65f blue:0.65f alpha:1.00f];
    UIColor *color16 = [UIColor colorWithRed:0.95f green:0.61f blue:0.19f alpha:1.00f];
    UIColor *color17 = [UIColor colorWithRed:0.82f green:0.33f blue:0.16f alpha:1.00f];
    UIColor *color18 = [UIColor colorWithRed:0.75f green:0.22f blue:0.16f alpha:1.00f];
    UIColor *color19 = [UIColor colorWithRed:0.75f green:0.76f blue:0.78f alpha:1.00f];
    UIColor *color20 = [UIColor colorWithRed:0.49f green:0.55f blue:0.55f alpha:1.00f];
    
    NSArray *array = [[NSArray alloc]initWithObjects:color1,color2,color3,color4,color5,color6,color7,color8,color9,color10,color11,color12,color13,color14,color15,color16,color17,color18,color19,color20, nil];
    return array;
    
}

@end
