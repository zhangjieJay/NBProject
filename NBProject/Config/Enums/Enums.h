//
//  Enums.h
//  wenzhong
//
//  Created by Jay on 17/3/29.
//  Copyright © 2017年 Jay. All rights reserved.
//

/**
 *  登录账户信息
 */

typedef NS_ENUM(NSInteger, MyLocalInfoType) {
    MyLocalInfoType_ID,//用户ID
    MyLocalInfoType_Phone,//电话
    MyLocalInfoType_AutoLogin,//是否自动登录
    MyLocalInfoType_password,//登录密码
};

/**
 *  获取当前设备的相关信息
 */

typedef NS_ENUM(NSInteger, NBDeviceType) {
    NBDeviceType_Name,//手机名(如浅水的鱼)
    NBDeviceType_Model,//iphone ipad
    NBDeviceType_LocalizedModel,//
    NBDeviceType_SystemName,//系统类型 IOS
    NBDeviceType_SystemVersion,//手机系统版本
    NBDeviceType_UUID//手机的UUID
};

/**
 *  本地数据库操作类型
 */
typedef  NS_ENUM(NSInteger,NBDBExcuteType){
    NBDBExcuteType_create = 0,//创建表
    NBDBExcuteType_pen,//打开数据库
    NBDBExcuteType_close,//关闭数据库
    NBDBExcuteType_add,//增加数据
    NBDBExcuteType_delete,//删除数据
    NBDBExcuteType_revise,//修改数据
    NBDBExcuteType_query//查询数据
};
/**
 *  预览图片数据源的格式 (暂时支持本地图片和网络连接url图片)
 */
typedef  NS_ENUM(NSInteger,NBImageSourceType){
    NBImageSourceType_name = 0,//本地图片
    NBImageSourceType_url,//网络地址
    NBImageSourceType_aaset //相册格式
};

typedef NS_ENUM(NSInteger, NBCornerPosition) {
    NBCornerPosition_None,
    NBCornerPosition_Top,
    NBCornerPosition_Left,
    NBCornerPosition_Bottom,
    NBCornerPosition_Right,
    NBCornerPosition_All
};


#ifndef Enums_h
#define Enums_h


#endif /* Enums_h */
