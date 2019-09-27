//
//  WBNotification.h
//  WBKit_Example
//
//  Created by penghui8 on 2018/3/22.
//  Copyright © 2018年 huipengo. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __IPHONE_11_0
#import <UserNotifications/UserNotifications.h>
#endif

typedef void(^WBNotificationAuthorizationCompletion)(BOOL granted, NSError *__nullable error);

typedef void(^WBReceiveRemoteNotificationCompletion)(NSDictionary *__nullable userInfo, UIApplicationState applicationState);

typedef void(^WBReceiveLocalNotificationCompletion)(NSDictionary *__nullable userInfo, UIApplicationState applicationState);


@interface WBNotification : NSObject

@property (nonatomic, strong, nullable, readonly) NSDictionary *launchOptions;

/// 授权推送通知
@property (nonatomic, copy) WBNotificationAuthorizationCompletion _Nullable authorizationCompletion;

/// 接受远程通知
@property (nonatomic, copy) WBReceiveRemoteNotificationCompletion _Nullable remoteNotificationCompletion;

/// 接受本地通知
@property (nonatomic, copy) WBReceiveLocalNotificationCompletion _Nullable localNotificationCompletion;

+ (instancetype _Nonnull)notification;

- (instancetype _Nonnull)init NS_UNAVAILABLE;
+ (instancetype _Nonnull)new NS_UNAVAILABLE;

/**
 点击推送通知，启动程序

 @param launchOptions 启动信息
 */
- (void)didLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;

/**
 注册推送通知
 */
+ (void)registerForRemoteNotification;

/**
 是否允许消息推送
 
 @param completion 回调
 */
+ (void)authorizationNotification:(void(^ _Nullable)(BOOL authorization))completion;

- (void)wb_didReceiveRemoteNotification:(NSDictionary * _Nullable)userInfo;

@end

@interface WBNotification (Tools)

/**
 转化设备Token为字符串

 @param deviceToken 设备token
 @return 字符串Token
 */
NSString * _Nullable wb_deviceToken(NSData * _Nullable deviceToken);

/**
 用一个空的本地推送解决角标为0，通知栏消息全部消除的问题，APP进入前台以及进入后台都进行判断

 @param timeInterval 执行时间
 */
void wb_execLocalNofitication(NSTimeInterval timeInterval);

/**
 打开APP系统设置
 */
void wb_enterAppSystemSetting(void);

@end

