//
//  WBNotificationTool.h
//  Fanstong
//
//  Created by penghui8 on 2018/3/29.
//  Copyright © 2018年 huipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBNotificationTool : NSObject

/// 设置推送通知
void wb_configureNotification(NSDictionary * _Nullable launchOptions);

/// 保存Token
void wb_saveNotificationDeviceToken(NSData * _Nullable deviceToken);

/// 上传token
void wb_putNotificationDeviceToken(NSString * _Nullable deviceToken);

@end
