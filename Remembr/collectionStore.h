//
//  collectionStore.h
//  Remembr
//
//  Created by Karan Thukral on 2013-10-05.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectionStore : NSObject

+ (collectionStore *)collectionStore;

- (NSArray *)returnIconPack;

- (NSArray *)returnColors;

@end
