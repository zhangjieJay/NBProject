//
//  UserDefaulUtil.h
//  wenzhong
//
//  Created by 峥刘 on 17/3/29.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NBUserDefaulUtil : NSObject

/**
 *  获取当前用户的某一信息
 *
 *  @param type 需要得到的信息
 *
 *  @return 返回值
 */
+ (NSString *)getMyLocalInfoType:(MyLocalInfoType)type;



/**
 *  更新当前用户的某一信息
 *
 *  @param type  需要更新的信息类型
 *  @param value 需要更新的值
 */
+ (void)updateMyLocalInfoType:(MyLocalInfoType)type value:(NSString *)value;



+(BOOL)isShowRemindViewWithNewVersion:(NSString*)version;//是否需要提醒


+(void)updateVersionViewInfoValue:(NSString *)value key:(NSString *)key;
+(void)updateLocalIgnoreVersion:(NSString *)ignoreVersion;

@end
