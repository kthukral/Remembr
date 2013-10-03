//
//  ImageStore.m
//  Remembr
//
//  Created by Karan Thukral on 2013-10-02.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "ImageStore.h"

@implementation ImageStore

+ (id)allocWithZone:(struct _NSZone *)zone{
    
    return [self imageStore];
    
}

+ (ImageStore *)imageStore{
    static ImageStore *imageStore = nil;
    
    if(!imageStore){
        imageStore = [[super allocWithZone:NULL]init];
    }
    
    return imageStore;
    
}

- (id)init{
    self = [super init];
    
    if(self){
        dictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setImage:(UIImage *)recievedImage forKey:(NSString *)recievedKey{
    
    [dictionary setObject:recievedImage forKey:recievedKey];
    
    NSString *imagePath = [self imagePathForKey:recievedKey];
    
    NSData *compressedImageData = UIImageJPEGRepresentation(recievedImage, 0.5);
    
    [compressedImageData writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)recievedKey{
    
    UIImage *resultImage = [dictionary objectForKey:recievedKey];
    
    if(!resultImage){
        NSString *path = [self imagePathForKey:recievedKey];
        resultImage = [UIImage imageWithContentsOfFile:path];

        if(resultImage){
            [dictionary setObject:resultImage forKey:recievedKey];
        }else{
            NSLog(@"ERROR: Unable to find image");
        }
    }
    return resultImage;
}

- (void)deleteImageForKey:(NSString *)recievedKey{
    if(!recievedKey){
        return;
    }
    [dictionary removeObjectForKey:recievedKey];
    
    NSString *path = [self imagePathForKey:recievedKey];
    
    [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
}

- (NSString *)imagePathForKey:(NSString *)recievedKey{
    
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:recievedKey];
}


@end
