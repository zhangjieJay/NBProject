//
//  AppDelegate.m
//  NBProject
//
//  Created by JayZhang on 17/6/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "NBRootViewController.h"
#import "NBTabBarController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#pragma mark ------------------------------- App进入
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog_Method
    // Override point for customization after application launch.
    
    [NBSystemObserver defaultObserver].showNetInfo = NO;//关闭网络提示
    [self setupAPNS];
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    NBTabBarController * tabvc =[NBTabBarController new];
    self.window.rootViewController = tabvc;
    [self.window makeKeyAndVisible];
    
    /*设置后台拉取数据的时间间隔*/
    [application setMinimumBackgroundFetchInterval:5];
    
    return YES;
}
#pragma mark ------------------------------- App即将变为后台程序,即不成为目前激活的程序
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog_Method
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [NB_KEYWINDOW blurEffect];
}

#pragma mark -------------------------------App已经变为后台程序
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog_Method
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [NB_KEYWINDOW blurEffect];
}

#pragma mark ------------------------------- App从后台运行变为目前激活的程序
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog_Method
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [NB_KEYWINDOW removeBlurEffect];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

#pragma mark ------------------------------- APP已经被激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog_Method
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [NB_KEYWINDOW removeBlurEffect];
}

#pragma mark ------------------------------- APP将要被划掉(关闭)
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark ------------------------------- 需要在时间间隔设置后操作
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
}

#pragma mark ------------------------------- 通过scheme调用App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    /*iOS 9.0以前*/
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    /*iOS 9.0及以后*/
    return YES;
}
#pragma mark ------------------------------- 获取devicetoken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //将其转换为字符串
    NSString * sToken = [NBTool getDeviceToken:deviceToken];
    
    [sToken description];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    /*注册远程推送通知失败*/
}

#pragma mark ------------------------------- 注册了通知
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}
#pragma mark ------------------------------- 收到远程(本地)通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    /**iOS 3.0 - 10.0*/
    [self dealRomoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    /**iOS 4.0 - 10.0*/
}
#pragma mark ------------------------------- 收到远程通知推送(目前10.0测试此方法不调用)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    /**iOS 7.0以后**/
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark ------------------------------- 即将推送通知(iOS 10.0以后在App内部收到通知)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    [self dealRomoteNotification:notification.request.content.userInfo];
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#pragma mark ------------------------------- 点击推送消息后回调(iOS 10.0及以后)
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [self dealRomoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}


#pragma mark ------------------------------- 请求推送权限
-(void)setupAPNS{
    /**
     *-Wdeprecated-declarations 方法废弃
     *-Wundeclared-selector   找不到方法的警告
     *-Wstrict-prototypes block参数不匹配
     */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([UIDevice currentDevice].systemVersion.doubleValue < 8.0) {
        /*注册并配置远程推送*/
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                               UIRemoteNotificationTypeSound |
                                                                               UIRemoteNotificationTypeBadge)];
    }else if([UIDevice currentDevice].systemVersion.doubleValue < 10.0) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];//注册远程推送
        /*配置远程推送提醒的方式*/
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings  settingsForTypes:UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert categories:nil]];
    }else{
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if (granted) {
                if( !error ){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }
        }];
    }
#pragma clang diagnostic pop

}
#pragma mark ------------------------------- 系统时间发生改变
-(void)applicationSignificantTimeChange:(UIApplication*)application{
    
}

-(void)dealRomoteNotification:(NSDictionary *)info{
    NSLog(@"info:%@",info);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
}
@end
