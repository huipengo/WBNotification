//
//  WBNotificationTool.h
//  Fanstong
//
//  Created by penghui8 on 2018/3/29.
//  Copyright © 2018年 huipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBNotificationTool : NSObject

/** 设置推送通知 */
void wb_configureNotification(NSDictionary * _Nullable launchOptions);

/** iOS9 点击推送通知执行此方法 */
void wb_applicationDidReceiveRemoteNotification(UIApplication *application, NSDictionary *userInfo);

/** 保存 Token */
void wb_saveNotificationDeviceToken(NSData * _Nullable deviceToken);

/** 上传 token */
void wb_putNotificationDeviceToken(NSString * _Nullable deviceToken);

@end
