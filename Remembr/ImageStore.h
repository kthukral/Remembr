//
//  ImageStore.h
//  Remembr
//
//  Created by Karan Thukral on 2013-10-02.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStore : NSObject

{
    NSMutableDictionary *dictionary;
}

+ (ImageStore *)imageStore;

- (void)setImage:(UIImage *)recievedImage forKey:(NSString *)recievedKey;

- (UIImage *)imageForKey:(NSString *)recievedKey;

- (void)deleteImageForKey:(NSString *)recievedKey;

- (NSString *)imagePathForKey:(NSString *)recievedKey;

@end
