//
//  ImageStore.m
//  Remembr
//
//  Created by Karan Thukral on 2013-10-04.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "ImageStore.h"

@implementation ImageStore

+ (id)allocWithZone:(NSZone *)zone{
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

- (void)setImage:(UIImage *)image forKey:(NSString *)key{
    
    [dictionary setObject:image forKey:key];
    
    //Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data,
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
    
}

- (UIImage *)imageForKey:(NSString *)key{
    
    // If possible, get it from the dictionary
    UIImage *result = [dictionary objectForKey:key];
    
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        
        // If we found an image on the file system, place it into the cache
        if (result)
            [dictionary setObject:result forKey:key];
        else
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
    }
    return result;

    
}

- (void)deleteImageForKey:(NSString *)key{
    
    if(!key)
        return;
    
    [dictionary removeObjectForKey:key];
    
    NSString *path = [self imagePathForKey:key];
    
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:NULL];
    
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
