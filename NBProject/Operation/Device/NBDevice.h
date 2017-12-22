//
//  NBDevice.h
//  NBProject
//
//  Created by JayZhang on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDevice : NSObject
@property(nonatomic,assign)BOOL isIphoneX;//是否是iPhoneX
@property(nonatomic,assign)CGFloat statuBarHeight;//状态栏高度
@property(nonatomic,assign)CGFloat navigationBarHeight;//导航栏高度
@property(nonatomic,assign)CGFloat tabBarHeight;//状态栏高度



+(instancetype)defaultDevice;

-(NSString *)getUUID;
-(NSString *)getName;
-(NSString *)getModel;
-(NSString *)getSystemName;
-(NSString *)getSystemVersion;
/**
 *  查看设备系统位数
 *
 *  @return 系统位数x86_64
 */
- (NSString *)getMachineSystem;//获取系统位数

-(NSString *)getPhoneType;//获取手机类型
-(NSString *)getDeviceName;//获取设备类型




@end
