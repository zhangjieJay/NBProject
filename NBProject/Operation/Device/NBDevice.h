//
//  NBDevice.h
//  NBProject
//
//  Created by JayZhang on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDevice : NSObject

+(NSString *)getUUID;
+(NSString *)getName;
+(NSString *)getModel;
+(NSString *)getSystemName;
+(NSString *)getSystemVersion;
/**
 *  查看设备系统位数
 *
 *  @return 系统位数x86_64
 */
+ (NSString *)getMachineSystem;//获取系统位数

+(NSString *)getPhoneType;//获取手机类型
+ (NSString *)getDeviceName;//获取设备类型




@end
