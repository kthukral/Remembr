//
//  AppDelegate.m
//  Remembr
//
//  Created by Karan Thukral on 2013-08-24.
//  Copyright (c) 2013 Karan Thukral. All rights reserved.
//

#import "AppDelegate.h"
#import "CategoryStore.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"]) {
        //First Launch category creation
        [[CategoryStore categoryStore]createCategoryWithTitle:@"Places" withColor:[UIColor colorWithRed:0.18f green:0.24f blue:0.31f alpha:1.00f] andImageName:@"94.png"];
        [[CategoryStore categoryStore]createCategoryWithTitle:@"People" withColor:[UIColor colorWithRed:0.20f green:0.60f blue:0.86f alpha:1.00f] andImageName:@"60.png"];
        [[CategoryStore categoryStore]createCategoryWithTitle:@"To Do" withColor:[UIColor colorWithRed:0.09f green:0.63f blue:0.53f alpha:1.00f] andImageName:@"95.png"];
        [[CategoryStore categoryStore]createCategoryWithTitle:@"School" withColor:[UIColor colorWithRed:0.68f green:0.47f blue:0.77f alpha:1.00f] andImageName:@"10.png"];
        [[CategoryStore categoryStore]createCategoryWithTitle:@"Music" withColor:[UIColor colorWithRed:0.91f green:0.30f blue:0.24f alpha:1.00f] andImageName:@"64.png"];
        [[CategoryStore categoryStore]createCategoryWithTitle:@"Movies" withColor:[UIColor colorWithRed:0.95f green:0.61f blue:0.06f alpha:1.00f] andImageName:@"73.png"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    CategoryViewController *categoryView = [[CategoryViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:categoryView];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL success = [[CategoryStore categoryStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the Categories");
    } else {
        NSLog(@"Could not save any of the Categories");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
