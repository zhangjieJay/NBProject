//
//  NBSystemObserver.m
//  NBProject
//
//  Created by Jay on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBSystemObserver.h"
#import <MediaPlayer/MediaPlayer.h>
#import <SystemConfiguration/SCNetworkReachability.h>


@interface NBSystemObserver()

@property(nonatomic,strong)Reachability * hostReachability;
@property(nonatomic,strong)NBVolumeBar * volumeBar;
@property(nonatomic,strong)MPVolumeView * volumeView;
@property(nonatomic,strong)UISlider * slider;

@end

@implementation NBSystemObserver

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+(instancetype)defaultObserver{
    
    static NBSystemObserver * observer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (observer == nil) {
            observer = [[NBSystemObserver alloc] initInstance];
        }
    });
    
    return observer;
}

/**
 *  初始化一个父类对象
 *
 *  @return 一个本类对象
 */
-(instancetype)initInstance{
    
    self = [super init];
    if (self) {
        self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
        if ([self.hostReachability currentReachabilityStatus] == NotReachable) {
            [NBTool showMessage:@"当前网络不可用，请检查你的网络设置"];
            self.isConnectted = NO;
        }
        
        [self.hostReachability startNotifier];
        [self addObservers];
        [self getSystemVolumSlider];
    }
    return self;
}


/**
 *  对于init方法进行处理抛出异常
 *
 */
- (instancetype)init
{
    @throw @"初始化对象失败,请采用类方法defaultObserver初始化单例对象.";
    
    return nil;
}


/**
 *  添加观察者
 *
 */
-(void)addObservers{
    //系统声音变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(volumeChanged:) name:NBSystemVolumeChangedNotification object:nil];
    
    //系统网络变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

/** 改变铃声 的 通知
 
 "AVSystemController_AudioCategoryNotificationParameter" = Ringtone;    // 铃声改变
 "AVSystemController_AudioVolumeChangeReasonNotificationParameter" = ExplicitVolumeChange; // 改变原因
 "AVSystemController_AudioVolumeNotificationParameter" = "0.0625";  // 当前值
 "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" = 0; 最小值
 
 
 改变音量的通知
 "AVSystemController_AudioCategoryNotificationParameter" = "Audio/Video"; // 音量改变
 "AVSystemController_AudioVolumeChangeReasonNotificationParameter" = ExplicitVolumeChange; // 改变原因
 "AVSystemController_AudioVolumeNotificationParameter" = "0.3";  // 当前值
 "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" = 0; 最小值
 */
-(void)volumeChanged:(NSNotification *)notifi{
    

    
    //    NSString * style = [notifi.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    CGFloat value = [[notifi.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
    self.volumeBar.alpha = 1;
    
    [self showVolumeBarWithValue:value];
    
    //    if ([style isEqualToString:@"Ringtone"]) {
    //        NSLog(@"铃声改变");
    //        [self.volumeBar refreshVolumeBarWithValue:value];
    //
    //    }else if ([style isEqualToString:@"Audio/Video"]){
    //        NSLog(@"音量改变 当前值:%f",value);
    //        [self.volumeBar refreshVolumeBarWithValue:value];
    //
    //    }
}

-(NBVolumeBar *)volumeBar{
    
    if (!_volumeBar) {
        _volumeBar = [[NBVolumeBar alloc]init];
    }
    return _volumeBar;
}

#pragma mark - 音量控制
/*
 *获取系统音量滑块
 */
-(void )getSystemVolumSlider{
    
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, -1000, 100, 100)];
    volumeView.hidden = NO;
    self.volumeView = volumeView;
    
    static UISlider * volumeViewSlider;
    for (UIView* newView in volumeView.subviews) {
        if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)newView;
            self.slider = volumeViewSlider;
            
            break;
        }
    }
}


-(void)showVolumeBarWithValue:(CGFloat)value{
    
    
    [self.volumeBar refreshVolumeBarWithValue:value];
    
    [UIView animateWithDuration:.5f delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.volumeBar.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.volumeBar.alpha = 0;
        
    }];
    
    
}

/*!
 * 网络变化的时候唤起
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    if([curReach currentReachabilityStatus] == NotReachable){
        [NBSystemObserver defaultObserver].isConnectted = NO;
        [NBTool showMessage:@"网络不可用,请检查网络设置"];
    }
    else if ([curReach currentReachabilityStatus]== ReachableViaWiFi){
        [NBSystemObserver defaultObserver].isConnectted = YES;
        [NBTool showMessage:@"当前通过WiFi连接"];
    }
    else if ([curReach currentReachabilityStatus]== ReachableViaWWAN){
        [NBSystemObserver defaultObserver].isConnectted = YES;
        [NBTool showMessage:@"当前通过手机网络连接"];
    }
    else {
        [NBSystemObserver defaultObserver].isConnectted = NO;
        [NBTool showMessage:@"网络不可用"];
        
    }
    
}


@end
