//
//  ImageStore.h
//  Remembr
//
//  Created by Karan Thukral on 2013-10-04.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStore : NSObject

{
    NSMutableDictionary *dictionary;
}

+ (ImageStore *)imageStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;

@end
