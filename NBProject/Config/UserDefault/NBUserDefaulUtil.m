//
//  UserDefaulUtil.m
//  wenzhong
//
//  Created by JayZhang on 17/3/29.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBUserDefaulUtil.h"

@implementation NBUserDefaulUtil
+ (NSString *)getMyLocalInfoType:(MyLocalInfoType)type {
    //ID
    if (type == MyLocalInfoType_ID) {
        NSString *ID = [NSString stringWithFormat:@"%@", NB_GET_USERDEFAULT(@"userInfo")[@"data"][@"UserCode"]];
        
        
        return ID;
    }
    //是否需要自动登录
    else if (type == MyLocalInfoType_AutoLogin){
        
        NSString * isAuto = [NSString stringWithFormat:@"%@", NB_GET_USERDEFAULT(@"userInfo")[@"data"][@"isAuto"]];
        
        return isAuto;
        
    }
    //密码
    else if (type == MyLocalInfoType_password){
        
        NSString * password = [NSString stringWithFormat:@"%@", NB_GET_USERDEFAULT(@"userInfo")[@"data"][@"password"]];
        return password;
    }

    //电话
    else if (type == MyLocalInfoType_Phone) {
        if (NB_GET_USERDEFAULT(@"userInfo")[@"Mobile"] == nil) {
            return @"";
        }
        else {
            return [NSString stringWithFormat:@"%@", NB_GET_USERDEFAULT(@"userInfo")[@"data"][@"Mobile"]];
        }
    }
    
    else {
        return nil;
    }
    
    //        AutoNo = 5;
    //        BindIP = "";
    //        CardID = 511702197004241850;
    //        ContentTel = 13000000004;
    //        Email = "33333@qq.com";
    //        ForbidLoginFlag = 0;
    //        HeartbeatTime = 1462939402000;
    //        Images = "859acce9-7c0a-4376-bea3-0aa612806527.jpg";
    //        LastLoginIp = "118.114.92.164";
    //        LastLoginTime = 1488943723000;
    //        Mobile = 13000000004;
    //        OriginType = 0;
    //        QQ = "";
    //        RegisterTime = 1444657338000;
    //        ShopAddress = "\U6210\U90fd\U957f\U57ce\U91d1\U878d\U5927\U53a6";
    //        ShopName = "\U6587\U4f17\U5546\U5bb6\U4f1a\U5458";
    //        ShopQRAddr = "www./m/shop.htm?sid=654";
    //        SupplyID = "";
    //        UserAlias = "";
    //        UserCode = 310001;
    //        UserID = "859acce9-7c0a-4376-bea3-0aa612806527";
    //        UserName = "\U6587\U4f17\U5546\U5bb6\U4f1a\U5458";
    //        UserType = 2;
    //        weChat = "";
}


+ (void)updateMyLocalInfoType:(MyLocalInfoType)type
                        value:(NSString *)value {
    NSMutableDictionary *user = [NB_GET_USERDEFAULT(@"userInfo") mutableCopy];
    NSMutableDictionary *userInfo = [user[@"data"] mutableCopy];
    
    //平台账号
    if (type == MyLocalInfoType_ID) {
        [userInfo setValue:value forKey:@"UserCode"];
    }
    //电话
    else if (type == MyLocalInfoType_Phone) {
        [userInfo setValue:value forKey:@"Mobile"];
    }
    else if (type == MyLocalInfoType_AutoLogin) {
        [userInfo setValue:value forKey:@"isAuto"];
    }
    else if (type == MyLocalInfoType_password) {
        
        [userInfo setValue:value forKey:@"password"];
    }

    [user setValue:userInfo forKey:@"data"];
    NB_SET_USERDEFAULT(@"userInfo", user);
}



/**
 *  判断是否需要弹出更新版本
 */
+(BOOL)isShowRemindViewWithNewVersion:(NSString*)version{
    NSDate * dateNow = [NSDate date];
    NSTimeInterval internal = dateNow.timeIntervalSince1970;
    NSMutableDictionary * dic = NB_GET_USERDEFAULT(@"versionUpdate");
    if (!dic) {
        dic =[NSMutableDictionary dictionaryWithDictionary:@{@"ignoreVersion" : @"",//上次忽略的版本
                                                             @"ignoretime" : @"",//上次忽略的时间
                                                             @"ignoreStatus" : @""}];//clicked代表点击过忽略
        NB_SET_USERDEFAULT(@"versionUpdate", dic);
        return YES;
    }
    //又有新版本了
    else if (![dic[@"ignoreVersion"] isEqualToString:version]) {
        return YES;
    }
    //忽略更新
    else if ([dic[@"ignoreStatus"] isEqualToString:@"clicked"]){
        
        //忽略后时间超过三天提醒更新
        if(internal -[dic[@"ignoretime"] doubleValue] >= 3*24*60*60){
            return YES;
        }
        //忽略后未超过三天
        else{
            return NO;
        }
    }
    //未忽略更新但是未更新成功
    else if (![dic[@"ignoreStatus"] isEqualToString:@"clicked"]){
        
        return YES;
    }
    
    return NO;
    
}


//用户判断版本是否需要更新弹出的提示框 //点击忽略更新是存放忽略时间
+(void)updateVersionViewInfoValue:(NSString *)value key:(NSString *)key{
    
    NSMutableDictionary * dic = [NB_GET_USERDEFAULT(@"versionUpdate") mutableCopy];
    if (dic) {
        [dic setValue:value forKey:key];
        NB_SET_USERDEFAULT(@"versionUpdate", dic);
        NB_SYNCHRONIZE;
    }
}


//更新本地判断是否需要提示版本更新的信息
+(void)updateLocalIgnoreVersion:(NSString *)ignoreVersion{
    
    [NBUserDefaulUtil updateVersionViewInfoValue:ignoreVersion key:@"ignoreVersion"];//储存忽略时的版本
    
    NSDate * dateNow = [NSDate date];
    
    NSTimeInterval internal = dateNow.timeIntervalSince1970;
    
    [NBUserDefaulUtil updateVersionViewInfoValue:[NSString stringWithFormat:@"%lf",internal] key:@"ignoretime"];//储存忽略时间
    
    [NBUserDefaulUtil updateVersionViewInfoValue:@"clicked" key:@"ignoreStatus"];//储存点击过取消
    
}







@end
