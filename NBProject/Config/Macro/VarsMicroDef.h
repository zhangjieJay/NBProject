//
//  WZVarsMicroDef.h
//  wenzhong
//
//  Created by JayZhang on 17/3/20.
//  Copyright © 2017年 Jay. All rights reserved.
//

#ifndef VarsMicroDef_h
#define VarsMicroDef_h

#define NB_Debug

#define Param(id) id?id:@""
#define  WEAKSELF          __weak typeof(self)weakSelf = self;
#define NB_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define NB_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define BIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NB_TABBAR_HEIGHT         (BIsiPhoneX ? 83.f : 49.f)
#define NB_NAVI_HEIGHT           (BIsiPhoneX ? 88.f : 64.f)
#define NB_SAFE_SPACE            (BIsiPhoneX ? 24.f : 0.f)


#define NB_BOMMAX_HEIGHT  (NB_SCREEN_HEIGHT - NB_NAVI_HEIGHT)
#define NB_MIDMAX_HEIGHT  (NB_SCREEN_HEIGHT - NB_NAVI_HEIGHT - NB_TABBAR_HEIGHT)






#define NB_KEYWINDOW [UIApplication sharedApplication].windows.lastObject

/*********** NSUserDefault ***********/
#define NB_SET_USERDEFAULT(_key, _value)  [[NSUserDefaults standardUserDefaults] setValue:(_value) forKey:(_key)]
#define NB_GET_USERDEFAULT(_key) [[NSUserDefaults standardUserDefaults] objectForKey:(_key)]
#define NB_SYNCHRONIZE [[NSUserDefaults standardUserDefaults] synchronize]

#define sWidth(width) ([NBDevice defaultDevice].h_scale * width) /*等比例缩放因子*/
#define sHeight(height) ([NBDevice defaultDevice].w_scale * height)


/*********** UILayout ***********/
#define NB_Gap_03 sWidth(3.0f)
#define NB_Gap_05 sWidth(5.0f)
#define NB_Gap_10 sWidth(10.f)
#define NB_Gap_15 sWidth(15.f)
#define NB_Gap_20 sWidth(20.f)
#define NB_Gap_25 sWidth(25.f)
#define NB_Gap_30 sWidth(30.f)
#define NB_Gap_35 sWidth(35.f)
#define NB_Gap_40 sWidth(40.f)
#define NB_Gap_50 sWidth(50.f)
#define NB_Gap_60 sWidth(60.f)

/*********** Tag ***********/
#define NB_Tag_100 100
#define NB_Tag_200 200
#define NB_Tag_300 300

#define NB_Tag_1000 1000
#define NB_Tag_3000 3000
#define NB_Tag_5000 5000

#define NB_Tag_ShowView 27277
#define NB_Tag_BlurView 20160829



#define NB_Error_Disconnect @"网络连接不可用"
#define NB_Error_Request @"请求出错"
#define NB_Error_Data @"数据格式出错"
#define NB_Error_00 @"网络连接不可用"
#define NB_Code_File @"CodeFiles"

#define NBTEXTWCOLOR            [UIColor getColorNumber:0]
#define NBTEXTBCOLOR            [UIColor getColorNumber:1]
#define NBTGRAYCOLOR               [UIColor getColorNumber:30]
#define NBBACKCOLOR             [UIColor getColorNumber:10]
#define NBSEPCOLOR              [UIColor getColorNumber:35]

#define NBAPPCOLOR              [UIColor getColorNumber:720]
#define NBMINORCOLOR            [UIColor getColorNumber:710]



/*********** MVC ***********/
#define PROPERTY_NSNUMBER(num) @property(nonatomic,strong)NSNumber * num;
#define PROPERTY_NSSTRING(string) @property(nonatomic,copy)NSString * string;
#define PROPERTY_BOOL(isBool) @property(nonatomic,assign)BOOL isBool;



/*********** System Version ***********/
#define iOS7_Earlier ([UIDevice currentDevice].systemVersion.doubleValue < 7.0f)
#define iOS7_Later ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0f)

#define iOS8_Earlier ([UIDevice currentDevice].systemVersion.doubleValue < 8.0f)
#define iOS8_Later ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0f)

#define iOS9_Earlier ([UIDevice currentDevice].systemVersion.doubleValue < 9.0f)
#define iOS9_Later ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0f)

#define iOS10_Earlier ([UIDevice currentDevice].systemVersion.doubleValue < 10.f)
#define iOS10_Later ([UIDevice currentDevice].systemVersion.doubleValue >= 10.f)


#define iOS11_Earlier ([UIDevice currentDevice].systemVersion.doubleValue < 11.f)
#define iOS11_Later ([UIDevice currentDevice].systemVersion.doubleValue >= 11.f)


/**
 *  release模式下禁止NSLog
 */
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#define NSLog_Method NSLog(@"%s %zd",__func__,__LINE__);



#endif /* WZVarsMicroDef_h */


