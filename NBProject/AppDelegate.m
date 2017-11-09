//
//  AppDelegate.m
//  NBProject
//
//  Created by JayZhang on 17/6/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import "NBRootViewController.h"
#import "NBTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog_Method
    // Override point for customization after application launch.
    
    [NBSystemObserver defaultObserver].showNetInfo = NO;//关闭网络提示
    
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    NBTabBarController * tabvc =[NBTabBarController new];
    
    
    
    
    self.window.rootViewController = tabvc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  App即将变为后台程序,即不成为目前激活的程序
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog_Method
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [NB_KEYWINDOW blurEffect];

    
}

/**
 *  App已经变为后台程序
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog_Method
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [NB_KEYWINDOW blurEffect];

}

/**
 *  App从后台运行变为目前激活的程序
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog_Method
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [NB_KEYWINDOW removeBlurEffect];
}

/**
 *  APP已经被激活
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog_Method
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [NB_KEYWINDOW removeBlurEffect];


}

/**
 *  APP将要被划掉(关闭)
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
