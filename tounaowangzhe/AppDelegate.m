//
//  AppDelegate.m
//  huanle
//
//  Created by Sj03 on 2017/11/20.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import "AppDelegate.h"
#import "DSNavViewController.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>
#import "HZLaunchImageViewController.h"
#import "HomeAdvertisModel.h"
#import "YMWebViewController.h"
#import "JPUSHService.h"
#import "AliPayObject.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "HZGuideViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import <WXApi.h>

#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    NSArray *familyNames = [UIFont familyNames];
    //    for( NSString *familyName in familyNames )
    //    {
    //        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    //        for( NSString *fontName in fontNames )
    //        {
    //            printf( "\tFont: %s \n", [fontName UTF8String] );
    //        }
    //    }
    //
    //初始化极光推送
    [self initJpushSDKWithOptions:launchOptions];
    
    [self initWindowWithOptions:launchOptions];
    
    
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),] onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
                //            case SSDKPlatformTypeQQ:
                //                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                //                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                      appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                break;
                //             case SSDKPlatformTypeQQ:
                //                 [appInfo SSDKSetupQQByAppId:@"100371282"
                //                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                //                                    authType:SSDKAuthTypeBoth];
                //                 break;
            default:
                break;
        }
    }];
    
    
    
    return YES;
}

-(void)initJpushSDKWithOptions:(NSDictionary *)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    // NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:kJpushAppKey
                          channel:kChannel
                 apsForProduction:kIsProduct
            advertisingIdentifier:nil];
}

#pragma mark 界面初始化
- (void)initWindowWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    HZLaunchImageViewController *launchVC = [[HZLaunchImageViewController alloc] initWithDefaultImage];
    self.window.rootViewController = launchVC;
    [self.window makeKeyAndVisible];
    
    // 配置友盟SDK产品并并统一初始化
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
    // [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    [UMConfigure initWithAppkey:UMAppKey channel:kChannel];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    // NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                          channel:kChannel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    
    RACSubject *subject_init = [[RACSubject alloc] init];
    
    // 初始化用户信息
    UserInfo *userinfo =  [[UserInfo shareInstance] init];
    // 初始化mainController
    [[[subject_init  flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            if([ToolUtil isNeedShowGuideView]){
                //引导界面
                HZGuideViewController *guideVC = [[HZGuideViewController alloc] init];
                guideVC.block_guideViewFinished = ^{
                    [subscriber sendNext:@1];
                    [subscriber sendCompleted];
                };
                self.window.rootViewController = guideVC;
            } else {
                
                HZLaunchImageViewController *launchVC = [[HZLaunchImageViewController alloc] init];
                HttpRequestMode* model = [[HttpRequestMode alloc]init];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                model.parameters = params;
                model.url = StartAdURL;
                //            [[HttpClient sharedInstance] requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                //                HomeAdvertisModel *model = [[HomeAdvertisModel alloc] init];
                //                [model getDateForServer:response.result];
                //                if (model.isopen) {
                //                    launchVC.model = model;
                //                } else {
                //                    launchVC.block_activityViewClicked(1000);
                //                }
                //            } Failure:^(HttpRequest *request, HttpResponse *response) {
                //                [BasePopoverView showFailHUDToWindow:response.errorMsg];
                //
                //            } RequsetStart:^{
                //
                //            } ResponseEnd:^{
                //
                //            }];
                @weakify(launchVC);
                launchVC.block_activityViewClicked = ^(ActivityViewClickedTag clickedTag){
                    MSLog(@"广告页点击tag值:%ld",clickedTag);
                    @strongify(launchVC);
                    if (clickedTag == kActivityViewClickedView) {
                        // 进入了广告页面
                        YMWebViewController *webview = [[YMWebViewController alloc] init];
                        self.window.rootViewController = webview;
                        webview.urlStr = launchVC.model.redirectUrl;
                        webview.complete = ^{
                            [subscriber sendNext:@YES];
                            [subscriber sendCompleted];
                        };
                    } else {
                        [subscriber sendNext:@YES];
                        [subscriber sendCompleted];
                    }
                };
                self.window.rootViewController = launchVC;
            }
            
            return nil;
        }];
    }] flattenMap:^RACStream *(id value) {
        return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //            DSNavViewController *mainCtl = [[DSNavViewController alloc] initWithRootViewController:[[LoginViewController alloc]initWithComplete:^(NSInteger tag) {
            //                self.window.rootViewController = [[DSNavViewController alloc] initWithRootViewController:[MainViewController alloc]];
            //            }]];
            //            self.window.rootViewController = mainCtl;
            
            // 测试
            self.window.rootViewController = [[DSNavViewController alloc] initWithRootViewController:[MainViewController alloc]];
            
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        
    }];
    [subject_init sendNext:@1];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeActive" object:@"BecomeActive" userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知");
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知");
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:");
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:");
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif



@end

