//
//  NBDevice.m
//  NBProject
//
//  Created by JayZhang on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBDevice.h"
#import "sys/utsname.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <MediaPlayer/MediaPlayer.h>



@implementation NBDevice



#pragma mark -------------------------------- 单例方法
+(instancetype)defaultDevice
{
    static NBDevice * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[NBDevice alloc] initSelfObject];
        }
    });
    return instance;
}
#pragma mark -------------------------------- 禁止使用init
- (instancetype)init
{
    @throw @"请使用+defaultDevice方法进行初始化";
}


#pragma mark -------------------------------- 自定义初始化方法
- (instancetype)initSelfObject
{
    self = [super init];
    if (self) {
        self.autoScaled = NO;
        self.isIphoneX = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] bounds].size) : NO;
        
        if (self.isIphoneX) {
            self.statuBarHeight = 44.f;
            self.tabBarHeight = 83.f;
        }else{
            self.statuBarHeight = 20.f;
            self.tabBarHeight = 49.f;
        }
        self.navigationBarHeight = self.statuBarHeight + 44.f;
    }
    return self;
}

-(void)setAutoScaled:(BOOL)autoScaled{
    _autoScaled = autoScaled;
    if (_autoScaled) {
        CGFloat scale = [UIScreen mainScreen].bounds.size.width/375.f ;
        _w_scale =  scale >=1? scale:1;//1pt 多少个像素点
        scale = [UIScreen mainScreen].bounds.size.width/667.f;
        _h_scale =  scale >=1? scale:1;//1pt 多少个像素点
    }else{
        _w_scale = 1;//1pt 多少个像素点
        _h_scale = 1;//1pt 多少个像素点
    }
}

-(NSString *)getName{

    return [self getPropertyWithType:NBDeviceType_Name];

}
-(NSString *)getModel{
    return [self getPropertyWithType:NBDeviceType_Model];
}

-(NSString *)getSystemName{
    return [self getPropertyWithType:NBDeviceType_SystemName];
}

-(NSString *)getSystemVersion{
    return [self getPropertyWithType:NBDeviceType_SystemVersion];
}

-(NSString *)getUUID{
    return [self getPropertyWithType:NBDeviceType_UUID];
}

-(NSString *)getPropertyWithType:(NBDeviceType)type{
    
    UIDevice * device = [UIDevice currentDevice];
    NSString * value = @"";
    switch (type) {
        case NBDeviceType_Name:
            value = device.name;
            break;
        case NBDeviceType_Model:
            value = device.name;
            break;
        case NBDeviceType_LocalizedModel:
            value = device.name;
            break;
        case NBDeviceType_SystemName:
            value = device.systemName;
            break;
        case NBDeviceType_SystemVersion:
            value = device.systemVersion;
            break;
        case NBDeviceType_UUID:
            value = device.identifierForVendor.UUIDString;
            break;
        default:
            break;
    }
    return value;
}


- (NSString *)getMachineSystem{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}


-(NSString *)getPhoneType{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    
    return deviceString;
}




-(NSString *)getDeviceName{
    int mib[2];
    size_t len;
    char *machine;
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";

    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch6G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad4";
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPadAir2";
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPadmini4"; 
    if ([platform isEqualToString:@"i386"]) return @"iPhoneSimulator"; 
    if ([platform isEqualToString:@"x86_64"]) return @"iPhoneSimulator"; 
    return platform; 
}


@end
