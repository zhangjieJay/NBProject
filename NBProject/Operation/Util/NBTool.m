//
//  NBTool.m
//  NBProject
//
//  Created by 峥刘 on 17/6/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBTool.h"

#import <CommonCrypto/CommonDigest.h>/*MD5需要的头文件*/

@implementation NBTool


+ (CGSize)autoString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    return [NBTool autoString:string font:font width:width height:MAXFLOAT];
}
+ (CGSize)autoString:(NSString *)string size:(CGFloat )size width:(CGFloat)width{
    return [NBTool autoString:string font:[UIFont systemFontOfSize:size] width:width height:MAXFLOAT];
}

+ (CGSize)autoString:(NSString *)string size:(CGFloat )size width:(CGFloat)width height:(CGFloat)height{
    return [NBTool autoString:string font:[UIFont systemFontOfSize:size] width:width height:height];
}

+ (CGSize)autoString:(NSString *)string font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height
{
    CGSize autoSize = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return autoSize;
}


+(NSInteger)randomWithMinNum:(NSInteger)minNum maxNum:(NSInteger)maxNum
{
    NSInteger randomNum = arc4random() % (maxNum - minNum + 1) + minNum;
    return randomNum;
}


+ (BOOL)isEmpty:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (object == nil) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]||[object isEqualToString:@"null"] || [object isEqualToString:@"(null)"]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        if ([object floatValue] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}


//是否全部为数字
+(BOOL)isNumber:(NSString *)numStr
{
    NSString * numPre = @"^[0-9]*$";
    NSPredicate *regextestNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPre];
    BOOL isNum = [regextestNum evaluateWithObject:numStr];
    return isNum;
}

//验证是否全为汉字
+ (BOOL)isAllChinese:(NSString *)value
{
    NSString *number = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:value];
}

#pragma mark -------------------------------------------------------- 输入非负的整数或者小数
+ (BOOL)isPrice:(NSString *)price
{
    BOOL isPrice = NO;
    NSString * predicateString = @"(^[1-9]\\d*\\.?\\d{0,2}$)|(^0\\.\\d{0,2}$)|(^0$)";//第一位1-9 + 0或者多次数字 + 0或者一次小数点+ 0-2位数字 大于或者等于1的两位小数 或者0+小数点+出现0-2次的数字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateString];
    isPrice = [predicate evaluateWithObject:price];
    return isPrice;
};


//是否为电话号码
+ (BOOL)isPhoneNumber:(NSString *)phoneNo
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";//移动
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";//联通
    
    NSString * CT = @"^1((33|53|8[09]|7[07])\\d|349)\\d{7}$";//电信
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNo];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNo];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNo];
    BOOL res4 = [regextestct evaluateWithObject:phoneNo];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)isBankCardNumber:(NSString *)cardNo
{
    if ([NBTool isEmpty:cardNo]) {
        return NO;
    }
    int oddsum = 0;
    int evensum = 0;
    int allsum = 0;
    for (int i = 0; i< [cardNo length];i++) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i, 1)];
        int tmpVal = [tmpString intValue];
        if((i % 2) == 0){
            tmpVal *= 2;
            if(tmpVal>=10)
                tmpVal -= 9;
            evensum += tmpVal;
        } else {
            oddsum += tmpVal;
        }
    }
    
    allsum = oddsum + evensum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


//验证身份证
+ (BOOL)isIdentityCard:(NSString *)value
{
    if (value.length == 15) {
        NSString *pattern = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [predicate evaluateWithObject:value];
    }
    else if (value.length == 18) {
        NSString *pattern = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [predicate evaluateWithObject:value];
    }
    else {
        return NO;
    }
}




/**
 *  判断是否需要更新当前app
 *
 *  @param appStoreVersion app store 最新的版本
 *
 *  @return 是否需要去更新
 */
+(BOOL)isAppStoreVersion:(NSString *)appStoreVersion{
    
    BOOL need = NO;
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];//当前版本
    NSString * compstr = @".";
    NSArray * preArr = [currentVersion componentsSeparatedByString:compstr];
    NSArray * appArr = [appStoreVersion componentsSeparatedByString:compstr];
    NSInteger currentValue = 0;
    NSInteger appValue = 0;
    if (preArr.count != appArr.count) {//如果不等  则直接提示需要更关心
        need = YES;
    }else{

        for (NSInteger i = preArr.count - 1; i >= 0; i--) {
            currentValue += [preArr[i] integerValue] * pow(10, i);
        }
        for (NSInteger i = appArr.count - 1; i >= 0; i--) {
            appValue += [appArr[i] integerValue] * pow(10, i);
        }
        if(appValue > currentValue){
        
            need = YES;
        };
    }
    return need;

}





//md5转码
+ (NSString *)MD5String:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]] uppercaseString];
}


+ (NSString *)decimalNumber:(NSString *)num {
    
    /*关于精度的bug*/
    NSString *doubleString = [NSString stringWithFormat:@"%lf", [num doubleValue]];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    num = [decNumber stringValue];
    /*关于精度的bug*/
    
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", [NBTool isEmpty:num] ? @"0.00" : num]];
    NSDecimalNumber *product = [number decimalNumberByRoundingAccordingToBehavior:handler];
    
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@", product];
    NSRange pointRange = [result rangeOfString:@"."];//小数点位置
    
    //不存在小数，添加两个零
    if (pointRange.location == NSNotFound) {
        [result appendString:@".00"];
    }
    
    //存在小数
    else {
        NSString *pointString = [result substringFromIndex:pointRange.location + 1];//小数点后面数字字符串
        if (pointString.length == 1) {
            //只有一位小数，添加一个零
            [result appendString:@"0"];
        }
    }
    return result;
}

/**
 *  计算两个值的运算结果
 *  @param value1 参数1
 *  @param value2 参数2
 *  @param way 枚举值 + - * /
 *  @return 计算结果
 */

+ (NSString *)decimalValue1:(NSString *)value1 value2:(NSString *)value2 byWay:(calucateWay)way{
    
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSString *number1 = [NSString stringWithFormat:@"%@", [NBTool isEmpty:value1] ? @"0.00" : value1];
    NSString *number2 = [NSString stringWithFormat:@"%@", [NBTool isEmpty:value2] ? @"0.00" : value2];
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *product;
    switch (way) {
        case Adding:
            product = [decimalNumber1 decimalNumberByAdding:decimalNumber2 withBehavior:handler];
            break;
        case Subtracting:
            product = [decimalNumber1 decimalNumberBySubtracting:decimalNumber2 withBehavior:handler];
            break;
        case Multiplying:
            product = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2 withBehavior:handler];
            break;
        case Dividing:
            product = [decimalNumber1 decimalNumberByDividingBy:decimalNumber2 withBehavior:handler];
            break;
        default:
            break;
    }
    return [self decimalNumber:[product stringValue]];
}

+ (NSString *)getIPAddressIsIPV4:(BOOL)preferIPv4
{
    return [NBIPTool getIPAddressIsIPV4:preferIPv4];
}



//13位的格式毫秒
+ (NSString *)getPastDateSinceNow:(NSString *)timeStamp{
    
    return [NBTool gettDateSinceNow:timeStamp isFuture:NO];
}

+ (NSString *)getFutureDateSinceNow:(NSString *)timeStamp{
    
    return [NBTool gettDateSinceNow:timeStamp isFuture:YES];
    
}
/**
 *  返回如 4小时后    1小时前等字符串
 *  @param timeStamp 相差毫秒数:144000400000
 *  @param future 是过去还是将来
 *  @return 对应的字符串
 */
+(NSString *)gettDateSinceNow:(NSString *)timeStamp isFuture:(BOOL)future{
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = timeStamp.doubleValue/1000;
    // 时间差
    
    NSTimeInterval time;
    NSString * subffix = @"前";
    if (future) {
        time = createTime - currentTime;
        subffix = @"后";
    }else{
        time = currentTime - createTime;
    }
    
    NSInteger seconds = time;
    if (seconds<60) {
        return [NSString stringWithFormat:@"%ld秒%@",seconds,subffix];
    }
    // 秒转分钟
    NSInteger minutes = time/60;
    if (minutes<60) {
        return [NSString stringWithFormat:@"%ld分钟%@",minutes,subffix];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时%@",hours,subffix];
    }
    //秒转天数
    NSInteger days = time/3600.f/24.f;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld日%@",days,subffix];
    }
    //秒转月
    NSInteger months = time/3600.f/24.f/30.f;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月%@",months,subffix];
    }
    //秒转年
    NSInteger years = time/3600.f/24.f/30.f/12.f;
    return [NSString stringWithFormat:@"%ld年%@",years,subffix];
}

/**
 *  根据时间相差数 相对于1970 为毫秒
 *  @param timeStamp 相差毫秒数:144000400000
 *  @param formatter 时间格式:YYYY-MM-dd
 *  @return 对应的时间
 */
+ (NSString *)getDateWithTimeStamp:(NSString *)timeStamp formatter:(NSString *)formatter{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSString *standardDate = [format stringFromDate:date];
    return standardDate;
}

/**
 *  根据生日计算年龄
 *  @param birthday 生日 格式如:1990-01-22
 *  @return 年龄字符串
 */
+ (NSString *)calculateAgeWithBirthday:(NSString *)birthday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //当为设置过生日时出现错误年龄的显示
    if ([NBTool isEmpty:birthday]) {
        NSDate * dateNow = [NSDate date];
        NSString * dateNowStr = [formatter stringFromDate:dateNow];
        birthday = dateNowStr;
    }
    
    NSDate *date = [formatter dateFromString:birthday];
    double bornTimeStamp = [date timeIntervalSince1970];
    double nowTimeStamp = [[NSDate date] timeIntervalSince1970];
    double subTimeStamp = nowTimeStamp - bornTimeStamp;
    NSInteger years = subTimeStamp / 3600 / 24 / 365;
    return [NSString stringWithFormat:@"%ld",years];
}


/**
 *  根据米数转换成相关的信息
 *  @param meters 米数
 *  @return 转换后的字符串
 */
+ (NSString *)getDistanceWithMeters:(NSString *)meters
{
    float kilometers = [meters floatValue] / 1000;
    if (kilometers >= 1) {
        NSString * kilometre = [NBTool decimalNumber:[NSString stringWithFormat:@"%f",[meters floatValue]/1000.f]];
        return [NSString stringWithFormat:@"%@公里",kilometre];
    }
    else{
        int meter = [meters intValue] % 1000;
        return [NSString stringWithFormat:@"%d米",meter];
    }
}


/**
 *  将NSData类型的 DeviceToken 转换为字符串
 *  @param deviceToken 设备的devicetoken数据
 *  @return 转换后的字符串
 */
+ (NSString *)getDeviceToken:(NSData *)deviceToken{
    
    //    // 方式1
    //    NSMutableString *deviceTokenString1 = [NSMutableString string];
    //    const char *bytes = deviceToken.bytes;
    //    NSInteger iCount = deviceToken.length;
    //    for (int i = 0; i < iCount; i++) {
    //        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    //    }
    //    NSLog(@"方式1：%@", deviceTokenString1);
    
    NSString *deviceTokenString2 = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return  deviceTokenString2;
    
    //    <d3f19a84 14622e78 33083be7 976b07b6 d1897cd7 c77632fb d3e72f66 8bd9cf05>
    
    
}


#pragma mark -------------------------------------------------------- 将传入的字符串转化为Jason
/**
 *  将json格式的字符串转化为id类型的数组或者字典  无效json返回空
 *  @param string json格式的字符串
 *  @return 转换后的id
 */
+ (id)getJsonString:(NSString *)string
{
    if ([NBTool isEmpty:string]) {
        return nil;
    }
    
    if (![NSJSONSerialization isValidJSONObject:string]) {
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        id  obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        return obj;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return result;
}





#pragma mark -------------------------------------------------------- 获取一个颜色
/**
 *  根据自定义序号和透明度生成颜色(此方法中可以自定义颜色,规定对应序号)
 *  @param num 自定义的序号
 *  @return 目标颜色(默认为不透明)
 */
+ (UIColor *)getColorNumber:(NSInteger)num
{
    return [NBTool getColorNumber:num alph:1.f];
}
/**
 *  根据自定义序号和透明度生成颜色(此方法中可以自定义颜色,规定对应序号)
 *  @param num 自定义的序号
 *  @param alp 透明度
 *  @return 目标颜色
 */

+ (UIColor *)getColorNumber:(NSInteger)num alph:(CGFloat)alp{
    /*默认黑色*/
    CGFloat red = 0.f;
    CGFloat gre = 0.f;
    CGFloat blu = 0.f;
    
    switch (num) {
        case -1://透明色
            alp = 0.f;
            break;
        case 0://纯白-#FFFFFF
            red = 255.f;
            gre = 255.f;
            blu = 255.f;
            break;
        case 1://纯黑-#000000
            red = 0.f;
            gre = 0.f;
            blu = 0.f;
            break;
        case 5://白烟-#F5F5F5
            red = 245.f;
            gre = 245.f;
            blu = 245.f;
            break;
        case 10://亮灰-#DCDCDC
            red = 220.f;
            gre = 220.f;
            blu = 220.f;
            break;
        case 15://浅灰色-#D3D3D3
            red = 211.f;
            gre = 211.f;
            blu = 211.f;
            break;
        case 20://银白色-#C0C0C0
            red = 192.f;
            gre = 192.f;
            blu = 192.f;
            break;
        case 25://深灰色-#A9A9A9
            red = 169.f;
            gre = 169.f;
            blu = 169.f;
            break;
        case 30://灰色-#808080
            red = 128.f;
            gre = 128.f;
            blu = 128.f;
            break;
        case 35://暗淡的灰色-#696969
            red = 105.f;
            gre = 105.f;
            blu = 105.f;
            break;
            
            
        case 100://纯红-#FF0000
            red = 255.f;
            gre = 0.f;
            blu = 0.f;
            break;
        case 105://印度红-#CD5C5C
            red = 205.f;
            gre = 92.f;
            blu = 92.f;
            break;
        case 110://棕色-#A52A2A
            red = 165.f;
            gre = 42.f;
            blu = 42.f;
            break;
        case 115://耐火砖-#B22222
            red = 178.f;
            gre = 34.f;
            blu = 34.f;
            break;
        case 120://深红色-#8B0000
            red = 139.f;
            gre = 0.f;
            blu = 0.f;
            break;
        case 125://栗红-#800000
            red = 128.f;
            gre = 0.f;
            blu = 0.f;
            break;
        case 130://深粉色	#FF1493
            red = 255.f;
            gre = 20.f;
            blu = 147.f;
            break;
        case 135://粉红	#FFC0CB	255,192,203
            red = 255.f;
            gre = 192.f;
            blu = 203.f;
            break;
            
            
        case 200://深橙色-#FF8C00
            red = 255.f;
            gre = 140.f;
            blu = 0.f;
            break;
            
            
        case 300://纯黄-#FFFF00
            red = 255.f;
            gre = 255.f;
            blu = 0.f;
            break;
            
        case 400://纯绿-#008000
            red = 0.f;
            gre = 128.f;
            blu = 0.f;
            break;
        case 405://深绿色-#006400
            red = 0.f;
            gre = 100.f;
            blu = 0.f;
            break;
        case 410://酸橙绿-#32CD32
            red = 50.f;
            gre = 205.f;
            blu = 50.f;
            break;
        case 415://	酸橙色-#00FF00
            red = 0.f;
            gre = 255.f;
            blu = 0.f;
            break;
        case 420://查特酒绿-#7FFF00
            red = 127.f;
            gre = 255.f;
            blu = 0.f;
            break;
        case 425://草坪绿	-#7CFC00
            red = 124.f;
            gre = 252.f;
            blu = 0.f;
            break;
        case 430://绿黄色	-#ADFF2F
            red = 173.f;
            gre = 255.f;
            blu = 47.f;
            break;
            
        case 500://青色-#00FFFF
            red = 0.f;
            gre = 255.f;
            blu = 155.f;
            break;
        case 505://深绿宝石-#00CED1
            red = 0.f;
            gre = 206.f;
            blu = 209.f;
            break;
        case 510://深青色-#008B8B
            red = 0.f;
            gre = 139.f;
            blu = 139.f;
            break;
        case 515://适中的绿宝石-#48D1CC
            red = 72.f;
            gre = 209.f;
            blu = 204.f;
            break;
            
            
            
        case 600://纯蓝-#0000FF
            red = 0.f;
            gre = 255.f;
            blu = 255.f;
            break;
        case 605://适中的蓝色-#0000CD
            red = 0.f;
            gre = 0.f;
            blu = 205.f;
            break;
        case 610://皇军蓝-#4169E1
            red = 65.f;
            gre = 104.f;
            blu = 225.f;
            break;
        case 615://淡钢蓝	-#B0C4DE
            red = 176.f;
            gre = 196.f;
            blu = 222.f;
            break;
            
            
            
        case 700://灯笼海棠(紫红色)-#FF00FF
            red = 255.f;
            gre = 0.f;
            blu = 255.f;
            break;
            
        case 705://紫罗兰-#EE82EE
            red = 238.f;
            gre = 130.f;
            blu = 238.f;
            break;
        case 710://兰花的紫色-#DA70D6
            red = 218.f;
            gre = 112.f;
            blu = 214.f;
            break;
            
        default:
            red = 0.f;
            gre = 0.f;
            blu = 0.f;
            break;
    }
    return [NBTool getColorWithRed:red green:gre blue:blu alpha:alp];
}
/**
 *  根据RGB及透明度生成颜色
 *  @param red 红
 *  @param green 绿
 *  @param blue 蓝
 *  @param alp 透明度
 *  @return 目标颜色
 */
+ (UIColor *)getColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alp{
    
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alp];
    
}

/**
 *  根据参数生成需要的字体
 *  @param size 字体大小
 *  @param name 字体名称
 *  @return 目标字体(不加粗)
 */
+(UIFont *)getFont:(CGFloat)size name:(NSString *)name{
    
    UIFont * font = [UIFont fontWithName:name size:size];
    if (font) {
        return font;
    }else{
     return [NBTool getFont:size];
    }
}

/**
 *  根据参数生成需要的字体
 *  @param size 字体大小
 *  @return 目标字体(不加粗)
 */
+(UIFont *)getFont:(CGFloat)size{
    return [NBTool getFont:size bold:NO];
}

/**
 *  根据参数生成需要的字体
 *  @param font 字体大小
 *  @param bold 是否加粗
 *  @return 目标字体
 */
+(UIFont *)getFont:(CGFloat)font bold:(BOOL)bold{
    
    UIFont * fontNormal;
    if (bold) {
        fontNormal = [UIFont boldSystemFontOfSize:font];
    }else{
        fontNormal = [UIFont systemFontOfSize:font];
    }
    return fontNormal;
}

/**
 *  获取最前端的KeyWindow 可能会有键盘所以的window
 */
+(UIWindow *)getForfontWindow{
    UIWindow * window;
    for(UIWindow * tempWindow in [UIApplication sharedApplication].windows){
        //键盘所在的层次
        if([tempWindow isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]){
            window = tempWindow;
            break;
        }else{//其他情况
            window = tempWindow;
        }
    }
    return window;
}

/**
 *  获取当前视图控制器
 */
+(UIViewController *)getCurrentViewController{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // modal展现方式的底层视图不同
    // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
    UIView *firstView = [keyWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    
    UIViewController *vc = [NBTool getViewControllerWithView:secondView];
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
    
}



/**
 *  根据提供的视图找到视图所在的控制器
 *  @param view 参考视图
 *  @return 当前视图控制器
 */
+ (UIViewController *)getViewControllerWithView:(UIView *)view {
    if(view==nil) return nil;
    while (1) {
        //如果响应链的下一个响应者是视图控制器
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
            break;
        }
        if(view==nil) return nil;
        view = view.superview;
    }
}






/**
 *  根据字符串生成不可变富文本
 *  @param string 字符串内容
 *  @param size 字体尺寸
 *  @param color 字体颜色
 *  @return 可变富文本信息
 */
+(NSMutableAttributedString *)getmuAttributedString:(NSString *)string font:(CGFloat)size textColor:(UIColor *)color{

    return [[NSMutableAttributedString alloc]initWithAttributedString:[NBTool getmuAttributedString:string font:size textColor:color]];
}
/**
 *  根据字符串生成可变富文本
 *  @param string 字符串内容
 *  @param size 字体尺寸
 *  @param color 字体颜色
 *  @return 可变富文本信息
 */
+(NSAttributedString *)getAttributedString:(NSString *)string font:(CGFloat)size textColor:(UIColor *)color{
    if ([NBTool isEmpty:string]) {
        string = @"";
    }
    NSAttributedString * atString = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName :[NBTool getFont:size],NSForegroundColorAttributeName:color}];
    return atString;
}

/**
 *  keyWindow展示提示信息
 *  @param message 提示信息
 */
+(void)showMessage:(NSString *)message
{
    UIWindow * window = NB_KEYWINDOW;
    UIView *showview =  [[UIView alloc]init];
    showview.tag = NB_Tag_ShowView;
    UIView * view = [window viewWithTag:NB_Tag_ShowView];
    if (view) {//移除原有的view可能会多层,所以移除
        [view removeFromSuperview];
        view = nil;
    }
    showview.backgroundColor = [NBTool getColorNumber:35];
    showview.alpha = 1.0f;
    showview.tag = NB_Tag_ShowView;
    [window addSubview:showview];
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    CGSize LabelSize = [NBTool autoString:message font:[NBTool getFont:15.f] width:NB_SCREEN_WIDTH - NB_Gap_40 height:NB_SCREEN_HEIGHT];
    
    
    label.frame = CGRectMake(NB_Gap_10, NB_Gap_10, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [NBTool getColorNumber:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor =[NBTool getColorNumber:-1];
    label.font = [NBTool getFont:15.f];
    [showview addSubview:label];
    double time = 1.5 * (LabelSize.height/15.f);
    showview.frame = CGRectMake((NB_SCREEN_WIDTH - LabelSize.width - NB_Gap_20)/2.f,NB_SCREEN_HEIGHT- (LabelSize.height + NB_Gap_20)-100.f , LabelSize.width + NB_Gap_20, LabelSize.height + NB_Gap_20);
    [showview drawBezierCornerWithRatio:NB_Gap_03];
    [UIView animateWithDuration:1.5f delay:time options:UIViewAnimationOptionCurveLinear animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        if (showview) {
            [showview removeFromSuperview];
        }
    }];

}

/**
 *  返回找到的俯视图没找到则返回空
 *  @param sClass 想要查找的父视图类的名称
 *  @param child 子视图
 *  @return 查找的结果
 */
+(UIView *)recurseTogetSuperView:(NSString *)sClass childView:(UIView *)child{

    UIView * view = child.superview;
    
    if (view && [sClass isEqualToString:NSStringFromClass([view class])]) {
        
        return view;
    }else{
        
        return [NBTool recurseTogetSuperView:sClass childView:view];
    }

}
/**
 *  返回找到的俯视图没找到则返回空
 *  @param sClass 想要查找的父视图类的名称
 *  @param child 子视图
 *  @return 查找的结果
 */
+(UIView *)circulateTogetSuperView:(NSString *)sClass childView:(UIView *)child{
    
    UIView * view = child.superview;
    
    while (![NSStringFromClass([view class]) isEqualToString:sClass]) {
        view = view.superview;
    }
    return view;
    
}






@end
