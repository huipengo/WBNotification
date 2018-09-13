# WBNotification

[![CI Status](https://img.shields.io/travis/彭辉/WBNotification.svg?style=flat)](https://travis-ci.org/彭辉/WBNotification)
[![Version](https://img.shields.io/cocoapods/v/WBNotification.svg?style=flat)](https://cocoapods.org/pods/WBNotification)
[![License](https://img.shields.io/cocoapods/l/WBNotification.svg?style=flat)](https://cocoapods.org/pods/WBNotification)
[![Platform](https://img.shields.io/cocoapods/p/WBNotification.svg?style=flat)](https://cocoapods.org/pods/WBNotification)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WBNotification is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WBNotification'
```

###使用简单说明
#####注册推送通知方法：

1、`WBAppDelegate.m` 里面导入头文件 </br>

`#import "WBNotificationTool.h"` </br>


2、`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}` 方法里面添加注册推送通知代码：</br>

  <mark>wb_configureNotification(launchOptions);</mark>


3、在 `WBAppDelegate.m` 里面添加如下代码：</br>

`- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    wb_saveNotificationDeviceToken(deviceToken);
}`

4、`WBNotificationTool.m`类里面做如下处理即可做到点击通知栏一条消息，消失一条消息，而不是全部消失：</br>

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

5、打开系统设置推送界面方法：</br>
    
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


</br>

### Push 功能自测：
1、先打开 `Keychain Access`，点击 `证书`，再选中相应证书(`小三角不要展开`) -> `导出证书` -> 选择 `个人信息交换格式选项(.p12)` 保存；

2、在终端 `cd *.p12` 所在目录文件，然后输入以下命令生成 `*.pem` 文件；
> openssl pkcs12 -in ck.p12 -out ck.pem -nodes

3、拷贝 `ck.pem` 文件到 `Demo` 中的 `Push_Beta` 文件夹，并在 `Push_Beta.php` 做相应修改（`替换生成*.pem文件时的密码，device token，推送内容等`）；

4、在终端执行命令：`cd 到 Push_Beta` 文件夹，再执行 `php Push_Beta.php` 即可验证生成的 `push 证书是否有效` 以及 `项目中推送功能` 是否正常；

---
* 具体使用可查看Demo，若喜欢请Star，谢谢~~~

简书地址：[https://www.jianshu.com/p/adac65fbd299](https://www.jianshu.com/p/adac65fbd299)

## License

WBNotification is available under the MIT license. See the LICENSE file for more info.
