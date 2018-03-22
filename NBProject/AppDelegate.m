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


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
#import <RennSDK/RennSDK.h>



@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#pragma mark ------------------------------- App进入
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog_Method
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [NBSystemObserver defaultObserver].showNetInfo = YES;//关闭网络提示
    [NBDevice defaultDevice].autoScaled = NO;            //自动适配屏幕尺寸比例关闭
    
    [self setupAPNS];                                     //配置是否能够接收通知
    [self setupShareSDK];                                 //配置分享
    [self setupThemeColor];                               //设置主题颜色
    
    
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    NBTabBarController * tabvc =[NBTabBarController new];
    self.window.rootViewController = tabvc;
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark ------------------------------- App即将变为后台程序,即不成为目前激活的程序
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog_Method
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark -------------------------------App已经变为后台程序
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog_Method
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

#pragma mark ------------------------------- App从后台运行变为目前激活的程序
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog_Method
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

#pragma mark ------------------------------- APP已经被激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog_Method
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
    
    NSLog(@"获取到通知信息:%@",userInfo);
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

-(void)setupShareSDK{
    /**初始化ShareSDK应用
     
     @param activePlatforms
     
     使用的分享平台集合
     
     @param importHandler (onImport)
     
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     
     @param configurationHandler (onConfiguration)
     
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     
     */
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeRenren),
                                        @(SSDKPlatformTypeFacebook),
                                        @(SSDKPlatformTypeTwitter),
                                        @(SSDKPlatformTypeGooglePlus)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeRenren:
                 [ShareSDKConnector connectRenren:[RennClient class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeFacebook:
                 [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
                                          appSecret:@"38053202e1a5fe26c80c753071f0b573"
                                        displayName:@"shareSDK"
                                           authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeTwitter:
                 [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
                                         consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
                                            redirectUri:@"http://mob.com"];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];
    
    
}
-(void)setupThemeColor{
    
    //导航栏背景色
    [[UINavigationBar appearance] setBarTintColor:NBAPPCOLOR];
    //导航条上UIBarButtonItem颜色
    [[UINavigationBar appearance] setTintColor:[UIColor getColorNumber:515]];
    //导航条上标题的颜色
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor getColorNumber:515]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    //导航条分割线颜色
//    [[UINavigationBar appearance]setShadowImage:[UIImage imageWithColor:NBSEPCOLOR]];
    
    //导航栏背景图片
//    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabbar_background.jpeg"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    
    
    
    //TabBar的背景颜色
    [[UITabBar appearance] setBarTintColor:NBAPPCOLOR];
    //TabBarItem选中图标的颜色,默认是蓝色
    [[UITabBar appearance] setTintColor:NBMINORCOLOR];
    //TabBarItem设置文字偏移量
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -3.5);
    
//    /*选中的tabbaritem背景图片*/
//    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"rec_pause"]];

//    [[UITabBar appearance]setBackgroundImage:[[UIImage imageNamed:@"tabbar_background.jpeg"] thumbnailToSize:CGSizeMake(NB_SCREEN_WIDTH, 49) rect:NO]];
    
    //TabBarItem文字的颜色
    NSDictionary * tabbarNormalTextAttributes = @{NSForegroundColorAttributeName:NBTGRAYCOLOR};
    NSDictionary * tabbarSelectedTextAttributes = @{NSForegroundColorAttributeName:[UIColor getColorNumber:100]};
    [[UITabBarItem appearance] setTitleTextAttributes:tabbarNormalTextAttributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:tabbarSelectedTextAttributes forState:UIControlStateSelected];
    
    //当某个class被包含在另外一个class内时，才修改外观。
//
//    UIPageControl *pageControl = [UIPageControl appearance];
//    pageControl.pageIndicatorTintColor = NBAPPCOLOR;
//    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];

    
}

@end
