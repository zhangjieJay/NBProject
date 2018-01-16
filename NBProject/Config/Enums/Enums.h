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
    NBImageSourceType_name = 0,         /*本地图片*/
    NBImageSourceType_url,              /*网络地址*/
    NBImageSourceType_aaset             /*相册格式*/
};

/**
 *  UIView类倒角枚举值
 */
typedef NS_ENUM(NSInteger, NBCornerPosition) {
    NBCornerPosition_None,              /*不倒角,默认值*/
    NBCornerPosition_Top,               /*上部(包括左右两边)*/
    NBCornerPosition_Left,              /*左部(包括上下两边)*/
    NBCornerPosition_Bottom,            /*下部(包括左右两边)*/
    NBCornerPosition_Right,             /*右部(包括上下两边)*/
    NBCornerPosition_All,               /*全部(包括四个角,可设置圆角大小)*/
    NBCornerPosition_AllRound           /*全部(倒角后为一个圆形)*/
};

/**
 *  UIButton 标题和图片的枚举值
 */
typedef NS_ENUM(NSInteger, NBButtonType) {
    NBButtonTypeTitle_Only,             /*只有标题,无图片*/
    NBButtonTypeTitle_Up,               /*标题在上部,图片在下部*/
    NBButtonTypeTitle_Left,             /*标题在左部,图片在右部*/
    NBButtonTypeTitle_Bottom,           /*标题在下部,图片在上部*/
    NBButtonTypeTitle_Right,            /*标题在右部,图片在左部*/
    NBButtonTypeTitle_None,             /*无标题只有图片*/
};




#ifndef Enums_h
#define Enums_h


#endif /* Enums_h */
