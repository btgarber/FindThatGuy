//
//  AppDelegate.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"O7Iy7ko920Vr53gvi0OL0d45oU0Dvdp83HC7coK2"clientKey:@"CWJbTX4kXSjo6WvPGSNvwZIp7vvlKrMuZgRQ3LmY"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationPayload != nil)
    {
        //[self application:application didReceiveRemoteNotification:notificationPayload];
    }
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([[User sharedUser] isRegistered])
        [[User sharedUser] loadFriends:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFriendsTable" object:nil];
        }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
    
    if([[userInfo objectForKey:@"command"] isEqualToString: PUSH_FRIEND_ADDED] ||
       [[userInfo objectForKey:@"command"] isEqualToString: PUSH_FRIEND_APPROVED])
    {
//        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//        //localNotif.fireDate = nil;
//        localNotif.timeZone = [NSTimeZone defaultTimeZone];
//        
//        // Notification details
//        localNotif.alertBody =  [userInfo objectForKey:@"message"];
//        // Set the action button
//        localNotif.alertAction = @"View";
//        
//        localNotif.soundName = UILocalNotificationDefaultSoundName;
//        localNotif.applicationIconBadgeNumber = 1;
//        
//        // Specify custom data for the notification
//        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
//        localNotif.userInfo = infoDict;
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        
    }
    
    if([[userInfo objectForKey:@"command"] isEqualToString: PUSH_FRIEND_REMOVED])
    {
        //[[User sharedUser] loadFriends:nil];
    }
    
    if([[User sharedUser] isRegistered])
        [[User sharedUser] loadFriends:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFriendsTable" object:nil];
        }];
    
    
    
}

@end
