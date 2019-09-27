//
//  WBNotification.m
//  WBKit_Example
//
//  Created by penghui8 on 2018/3/22.
//  Copyright © 2018年 huipengo. All rights reserved.
//

#import "WBNotification.h"

@interface WBNotification() <UNUserNotificationCenterDelegate>

@end

@implementation WBNotification

+ (void)load {
    [WBNotification wb_addNotificationCenterObserver];
}

- (void)dealloc {
    [WBNotification wb_removeNotificationCenterObserver];
}

+ (instancetype _Nonnull )notification {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    return _sharedInstance;
}

- (void)didLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions {
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        _launchOptions = launchOptions;
    } else {
        _launchOptions = nil;
    }
}

/**
 注册推送通知
 */
+ (void)registerForRemoteNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        [uncenter setDelegate:[WBNotification notification]];
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [uncenter requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            ![WBNotification notification].authorizationCompletion?:[WBNotification notification].authorizationCompletion(granted, error);
        }];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    /// 注册远端消息通知获取device token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

/**
 是否允许消息推送

 @param completion 回调
 */
+ (void)authorizationNotification:(void(^)(BOOL authorization))completion
{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                /**
                 * UNAuthorizationStatusNotDetermined : 没有做出选择
                 * UNAuthorizationStatusDenied        : 用户未授权
                 * UNAuthorizationStatusAuthorized    : 用户已授权
                 */
                !completion?:completion(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
            });
        }];
    }
    else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion?:completion(setting.types != UIUserNotificationTypeNone);
        });
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [self wb_didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark -- UNUserNotificationCenterDelegate
/** iOS10新增：处理前台收到通知的代理方法 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) {
    [self wb_userNotificationReceiveNotification:notification];
    completionHandler(UNNotificationPresentationOptionSound);
}

/** iOS10新增：处理后台点击通知的代理方法 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED {
    [self wb_userNotificationReceiveNotification:response.notification];
    completionHandler();
}

/** 自定义处理推送接收通知方法 */
- (void)wb_userNotificationReceiveNotification:(UNNotification *)notification __IOS_AVAILABLE(10.0) {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        /** 远程推送接受 */
        [self wb_didReceiveRemoteNotification:userInfo];
    }
    else {
        /** 本地推送接受 */
        [self wb_didReceiveLocalNotification:userInfo];
    }
}

- (void)wb_didReceiveRemoteNotification:(NSDictionary *)userInfo {
    !self.remoteNotificationCompletion?:self.remoteNotificationCompletion(userInfo, UIApplication.sharedApplication.applicationState);
}

- (void)wb_didReceiveLocalNotification:(NSDictionary *)userInfo {
    !self.localNotificationCompletion?:self.localNotificationCompletion(userInfo, UIApplication.sharedApplication.applicationState);
}

#pragma mark --
+ (void)wb_addNotificationCenterObserver {
    [NSNotificationCenter.defaultCenter addObserver:WBNotification.notification selector:@selector(wb_appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:WBNotification.notification selector:@selector(wb_appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:WBNotification.notification selector:@selector(wb_appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}

+ (void)wb_removeNotificationCenterObserver {
    [NSNotificationCenter.defaultCenter removeObserver:WBNotification.notification];
}

- (void)wb_appWillResignActive {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        wb_execLocalNofitication(0);
    });
}

- (void)wb_appDidEnterBackground {
    [WBNotification.notification didLaunchingWithOptions:nil];
}

- (void)wb_appWillTerminate {
    wb_execLocalNofitication(1);
}

@end

@implementation WBNotification (Tools)

/** 转化设备Token */
NSString * _Nullable wb_deviceToken(NSData * _Nullable deviceToken) {
    
    if (![deviceToken isKindOfClass:[NSData class]]) return nil;
    
    NSMutableString *hexToken = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSInteger count = deviceToken.length;
    for (NSInteger i = 0; i < count; i++) {
        [hexToken appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    
    return hexToken;
}

void wb_execLocalNofitication(NSTimeInterval timeInterval) {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        if (@available(iOS 11.0, *)) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
            notification.fireDate = fireDate;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.repeatInterval = 0;
            notification.alertBody = nil;
            notification.applicationIconBadgeNumber = -1;
            notification.soundName = nil;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

void wb_enterAppSystemSetting() {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        if (@available(iOS 10.0, *)) {
            NSDictionary *options = @{};
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
                    
                }];
            }
        }
        else {
            if (canOpen) {
                canOpen = [[UIApplication sharedApplication] openURL:url];
            }
        };
    });
}

@end
