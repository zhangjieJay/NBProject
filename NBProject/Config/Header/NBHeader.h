//
//  NBHeader.h
//  NBProject
//
//  Created by JayZhang on 17/8/18.
//  Copyright © 2017年 Jay. All rights reserved.
//

#ifndef NBHeader_h
#define NBHeader_h


/*基本的枚举 宏定义 闭包等 通知等*/
#import "Enums.h"                   //枚举
#import "Blocks.h"                  //block
#import "NBNotification.h"          //通知类

#import "VarsMicroDef.h"            //所有项目均可用宏定义
#import "ProjectMarco.h"            //针对每个项目的宏定义 如API



#import "BaseModel.h"               //所有模型的基类
#import "ParamModel.h"              //参数model
#import "UserEntity.h"              //用户model(暂时未用到)

#import "BaseViewController.h"      //所有视图控制器的基类
#import "NBWebViewController.h"     //WKWebView + JS
#import "UIColor+NBCategory.h"      //颜色类拓展


/*第三方的库文件*/
#import "JSONKit.h"
#import "Reachability.h"            //网络连接监控类
#import "AFNetworking.h"            //AF
#import <Masonry.h>                 //自动布局的第三方库
#import <IQKeyboardManager.h>       //键盘类
#import <UIImageView+WebCache.h>

//#import <TZImagePickerController.h>



/*自定义封装*/
//#import "NBSQLManager.h"

#import "NBDevice.h"
#import "NBAudio.h"             //将文字转化为语音并且播放
#import "BaseButton.h"          //重写 rect的button

#import "UIView+NBCategory.h"   
#import "UIImage+NBCategroy.h"
#import "UIView+NBAnimation.h"
#import "UIColor+NBCategory.h"
#import "NSDictionary+NBSerializing.h"
#import "UIControl+NBClicked.h"
#import "NBUserDefaulUtil.h"

#import "NBHudProgress.h"
#import "NBAlertView.h"
#import "NBSheetView.h"
#import "NBShareView.h"



#import "NBIPTool.h"//获取IP地址的类
#import "NBTool.h"//常用工具类
#import "NBNetWork.h"//网络请求类
#import "NBVolumeBar.h"//
#import "NBSystemObserver.h"//系统观察类(基于Reachability.h的小封装)
//#import "NBRefresh.h"
#import "NBStoreManager.h"
#import "NBCodeButton.h"
#import "NBBadgeButton.h"
#import "NBCountingLabel.h"
#import "NBTextView.h"
#import "NBRefresh.h"
#import "NBQRCodeTool.h"


#endif /* NBHeader_h */
