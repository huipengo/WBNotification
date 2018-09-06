//
//  WBNotificationTool.m
//  Fanstong
//
//  Created by penghui8 on 2018/3/29.
//  Copyright © 2018年 huipeng. All rights reserved.
//

#import "WBNotificationTool.h"
#import "WBNotification.h"
#import <ReactiveObjC/ReactiveObjC.h>

static NSString * const wbNotificationDeviceToken = @"wbNotificationDeviceToken";

@implementation WBNotificationTool

+ (void)load {
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         [WBNotification.notification didLaunchingWithOptions:nil];
         wb_execLocalNofitication(0);
     }];
    
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationWillTerminateNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         /// 杀死应用发送延迟1秒，否则红点不消失
         wb_execLocalNofitication(1);
     }];
}

/// 设置推送通知
void wb_configureNotification(NSDictionary * _Nullable launchOptions) {
    [WBNotification registerForRemoteNotification];
    [WBNotification.notification didLaunchingWithOptions:launchOptions];
    WBNotification.notification.remoteNotificationCompletion = ^(NSDictionary * _Nullable userInfo, UIApplicationState applicationState) {
        if ([userInfo isKindOfClass:NSDictionary.class]) {
            if (applicationState == UIApplicationStateActive) {
                
            }
            else if (applicationState == UIApplicationStateBackground) {

            }
            else if (applicationState == UIApplicationStateInactive) {
                wb_notificationMessageAction(userInfo);
            }
        }
    };
}

void wb_notificationMessageAction(NSDictionary *userInfo) {
    /// 程序启动3秒后执行，后台进入1.5秒后执行
    //NSInteger walltime = WBNotification.notification.launchOptions ? 3 : 1.5;
    /// push notification action
}

void wb_saveNotificationDeviceToken(NSData *deviceToken) {
    NSString *token = wb_deviceToken(deviceToken);
    if (token && token.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:wbNotificationDeviceToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

void wb_putNotificationDeviceToken(NSString *deviceToken) {
    __block NSString *token = deviceToken;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!token || (token.length <= 0)) {
            token = [[NSUserDefaults standardUserDefaults] objectForKey:wbNotificationDeviceToken];
        }
        if (token && token.length > 0) {
            /// request
        }
    });
}

@end
