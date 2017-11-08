//
//  WZVarsMicroDef.h
//  wenzhong
//
//  Created by 峥刘 on 17/3/20.
//  Copyright © 2017年 Jay. All rights reserved.
//

#ifndef VarsMicroDef_h
#define VarsMicroDef_h

#define Param(id) id?id:@""

#define  WEAKSELF __weak typeof(self)weakSelf = self;


#define NB_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define NB_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define NB_ESTIMATESCREEN_HEGHT  [UIScreen mainScreen].bounds.size.height -64.f
#define NB_SCALE_5 [UIScreen mainScreen].bounds.size.width/320.f
#define NB_SCALE_6 [UIScreen mainScreen].bounds.size.width/375.f


#define NB_KEYWINDOW [UIApplication sharedApplication].keyWindow

/*********** NSUserDefault ***********/
#define NB_SET_USERDEFAULT(_key, _value)  [[NSUserDefaults standardUserDefaults] setValue:(_value) forKey:(_key)]
#define NB_GET_USERDEFAULT(_key) [[NSUserDefaults standardUserDefaults] objectForKey:(_key)]
#define NB_SYNCHRONIZE [[NSUserDefaults standardUserDefaults] synchronize]


/*********** UILayout ***********/
#define NB_Gap_03 3.0f
#define NB_Gap_05 5.0f
#define NB_Gap_10 10.f
#define NB_Gap_15 15.f
#define NB_Gap_20 20.f
#define NB_Gap_25 25.f
#define NB_Gap_30 30.f
#define NB_Gap_35 35.f
#define NB_Gap_40 40.f
#define NB_Gap_50 50.f
#define NB_Gap_60 60.f

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



/*********** MVC ***********/
#define PROPERTY_NSNUMBER(num) @property(nonatomic,strong)NSNumber * num;
#define PROPERTY_NSSTRING(string) @property(nonatomic,copy)NSString * string;
#define PROPERTY_BOOL(isBool) @property(nonatomic,assign)BOOL isBool;



/*********** System Version ***********/
#define iOS7_Earlier ([UIDevice currentDevice].systemVersion.floatValue < 7.0f)
#define iOS7_Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)

#define iOS8_Earlier ([UIDevice currentDevice].systemVersion.floatValue < 8.0f)
#define iOS8_Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

#define iOS9_Earlier ([UIDevice currentDevice].systemVersion.floatValue < 9.0f)
#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define iOS10_Earlier ([UIDevice currentDevice].systemVersion.floatValue < 10.f)
#define iOS10_Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.f)


#define iOS11_Earlier ([UIDevice currentDevice].systemVersion.floatValue < 11.f)
#define iOS11_Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.f)


/**
 *  release模式下禁止NSLog
 */
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#define NSLog_Method NSLog(@"%s",__func__);



#endif /* WZVarsMicroDef_h */


