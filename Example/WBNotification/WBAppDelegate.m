//
//  WBAppDelegate.m
//  WBNotification
//
//  Created by 彭辉 on 09/05/2018.
//  Copyright (c) 2018 彭辉. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBViewController.h"
#import "WBNotificationTool.h"

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    WBViewController *rootViewController = [[WBViewController alloc] init];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationViewController.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
    self.window.rootViewController = navigationViewController;
    
    wb_configureNotification(launchOptions);
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    wb_saveNotificationDeviceToken(deviceToken);
}

@end
