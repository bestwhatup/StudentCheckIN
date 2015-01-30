//
//  AppDelegate.m
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self performSelector:@selector(CopyDBtoDocument)withObject:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)CopyDBtoDocument {
    NSString *db_Name = @"CheckIN.sqlite";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //if don't have folder. this function is create folder;
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }
    
    NSString *writeDBpath = [documentsDirectory stringByAppendingPathComponent:db_Name];
    
    BOOL foundInUsePath = [fileManager fileExistsAtPath:writeDBpath];
    
    if (foundInUsePath) {
        NSLog(@"DB Exists");
        return;
    }
    
    NSString *Source_dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:db_Name];
    
    BOOL copySuccess = [fileManager copyItemAtPath:Source_dbpath toPath:writeDBpath error:nil];
    
    if (!copySuccess) {
        NSAssert(0, @"failed to create db file %@",[error localizedDescription]);
    } else {
        NSLog(@"db has been copied");
    }
}

@end
