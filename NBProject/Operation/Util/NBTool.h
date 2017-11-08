//
//  NBTool.h
//  NBProject
//
//  Created by Jay on 17/6/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NBTool : NSObject

//  金额计算方式
typedef enum {
    Adding,
    Subtracting,
    Multiplying,
    Dividing,
}calucateWay;

#pragma mark ------------------------------- 文本自适应高度
+ (CGSize)autoString:(NSString *)string size:(CGFloat )size width:(CGFloat)width;
+ (CGSize)autoString:(NSString *)string size:(CGFloat )size width:(CGFloat)width height:(CGFloat)height;

+ (CGSize)autoString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;
+ (CGSize)autoString:(NSString *)string font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height;


#pragma mark ------------------------------- 获取一个随机数
+(NSInteger)randomWithMinNum:(NSInteger)minNum maxNum:(NSInteger)maxNum;

#pragma mark ------------------------------- 是否为空
+ (BOOL)isEmpty:(id)object;


#pragma mark ------------------------------- 验证数字，手机号码，银行卡，身份证，全部汉字
/*判断是否全为数字*/
+(BOOL)isNumber:(NSString *)string;

/*验证字符串全部为汉字*/
+ (BOOL)isAllChinese:(NSString *)value;

/*非负的整数或者小数*/
+ (BOOL)isPrice:(NSString *)price;

/*判断手机号*/
+ (BOOL)isPhoneNumber:(NSString *)phoneNo;

/*验证银行卡号*/
+ (BOOL)isBankCardNumber:(NSString *)cardNo;

/*验证身份证号*/
+ (BOOL)isIdentityCard:(NSString *)value;

/**
 *  对比当前APP版本和App Store版本是否需要更新
 *
 *  @return 是否需要更新(只对比版本)
 */
+(BOOL)isAppStoreVersion:(NSString *)appStoreVersion;





#pragma mark ------------------------------- MD5加密
+ (NSString *)MD5String:(NSString *)string;
#pragma mark ------------------------------- 只舍不入，保留小数点2位有效数字
+ (NSString *)decimalNumber:(NSString *)num;

#pragma mark ------------------------------- 货币计算（只舍不入，保留小数点2位有效数字)
+ (NSString *)decimalValue1:(NSString *)value1 value2:(NSString *)value2 byWay:(calucateWay)way;

+ (NSString *)getIPAddressIsIPV4:(BOOL)preferIPv4;

#pragma mark ------------------------------- date相关处理方法
+ (NSString *)getPastDateSinceNow:(NSString *)timeStamp;
+ (NSString *)getFutureDateSinceNow:(NSString *)timeStamp;
+ (NSString *)getDateWithTimeStamp:(NSString *)timeStamp formatter:(NSString *)formatter;
+ (NSString *)getDistanceWithMeters:(NSString *)meters;

+ (NSString *)getSandBoxDcoumentPath;
+ (NSString *)getSandBoxLibraryPath;
+ (NSString *)getSandBoxCachestPath;
/**
 *  根据生日计算年龄
 *  @param birthday 生日(格式：yyyy-MM-dd)
 *  @return 返回值
 */
+ (NSString *)calculateAgeWithBirthday:(NSString *)birthday;

/**
 *  查看设备的devicetoken
 *  @param deviceToken 获取到的devicetoken
 *  @return 转换后的字符串
 */
+ (NSString *)getDeviceToken:(NSData *)deviceToken;


/**
 *  根据生日计算年龄
 *  @param string 生日(格式：yyyy-MM-dd)
 *  @param size 字体大小
 *  @param color 字体颜色
 *  @return 返回值
 */
+(NSAttributedString *)getAttributedString:(NSString *)string font:(CGFloat)size textColor:(UIColor *)color;
+(NSMutableAttributedString *)getmuAttributedString:(NSString *)string font:(CGFloat)size textColor:(UIColor *)color;



#pragma mark ------------------------------- Jason字符串转化为对象
+ (id)getJsonString:(NSString *)string;

#pragma mark ------------------------------- 获取字体
+(UIFont *)getFont:(CGFloat)size;
+(UIFont *)getFont:(CGFloat)font bold:(BOOL)bold;
+(UIFont *)getFont:(CGFloat)size name:(NSString *)name;


#pragma mark ------------------------------- 获取当前的最前端的window
+(UIWindow *)getForfontWindow;
#pragma mark ------------------------------- 获取当前视图控制器
+(UIViewController *)getCurrentViewController;

+(void)showMessage:(NSString *)message;

#pragma mark ------------------------------- 递归查找子视图的父视图
+(UIView *)recurseTogetSuperView:(NSString *)sClass childView:(UIView *)child;
#pragma mark ------------------------------- 循环查找子视图的父视图
+(UIView *)circulateTogetSuperView:(NSString *)sClass childView:(UIView *)child;



@end
