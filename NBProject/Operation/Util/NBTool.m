//
//  NBTool.m
//  NBProject
//
//  Created by JayZhang on 17/6/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBTool.h"

#import <CommonCrypto/CommonDigest.h>/*MD5需要的头文件*/
#import <UserNotifications/UserNotifications.h>


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
#pragma mark ------------------------------- 是否打开推送通知
+(BOOL)isOpenNotification{
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    //        if (iOS10_Later) {
    //            __block BOOL isOpen = NO;
    //           __block BOOL isIn = NO;
    //            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * settings) {
    //                isIn = YES;
    //                    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
    //                        isOpen = YES;
    //                    }else{
    //                        isOpen = NO;
    //                    }
    //            }];
    //            while (!isIn) {
    //
    //                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[[NSDate date] dateByAddingTimeInterval:0.5]];
    //
    //            }
    //            return isOpen;
    //
    //        }else
    
    if (iOS8_Later) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            return NO;
        }else{
            return YES;
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            return NO;
        }else{
            return YES;
        }
    }
    //#pragma clang diagnostic pop
    
}





#pragma mark ------------------------------- md5转码
+ (NSString *)MD5String:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]] uppercaseString];
}

#pragma mark ------------------------------- 转化为两位小数 向上取舍
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
#pragma mark ------------------------------- 数字四则运算
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
#pragma mark ------------------------------- 获取本机的IPV4或者IPV6
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


+ (NSString *)getSandBoxDcoumentPath{
    return [NBTool getSandBoxPath:NSDocumentDirectory];
}

+ (NSString *)getSandBoxLibraryPath{
    return [NBTool getSandBoxPath:NSLibraryDirectory];
}

+(NSString *)getSandBoxCachestPath{
    return [NBTool getSandBoxPath:NSCachesDirectory];
}
+(NSString *)getSandBoxPath:(NSSearchPathDirectory)type{
    
    NSArray * paths=NSSearchPathForDirectoriesInDomains(type,NSUserDomainMask,YES);
    
    return paths.firstObject;
}


+ (NSString *)getFirstDayOfThisMonth{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *dateNow= [NSDate date];//获取到当前日期
    NSCalendar *calendar = [NSCalendar currentCalendar];//获取日历
    NSDate *firstDay;
    /*从月份当中取出第一天*/
    if (iOS8_Later) {
        [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:dateNow];
    }else{
        [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:dateNow];
    }
    NSString * sFirstDay = [formatter stringFromDate:firstDay];
#pragma clang diagnostic pop
    
    return sFirstDay;
    
}

+ (NSString *)getLastDayOfThisMonth{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (iOS8_Later) {
        [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:dateNow];
    }else{
        [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    }
    
    NSDateComponents *lastDateComponents;
    if (iOS8_Later) {
        lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitDay fromDate:firstDay];
    }else{
        lastDateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit |NSDayCalendarUnit fromDate:firstDay];
    }
    
    
    NSUInteger dayNumberOfMonth;
    if (iOS8_Later) {
        dayNumberOfMonth   = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateNow].length;
    }else{
        dayNumberOfMonth  = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:dateNow].length;
    }
#pragma clang diagnostic pop
    
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    NSString * sLastDay = [formatter stringFromDate:lastDay];
    
    return sLastDay;
}

+ (NSString *)getCurrentDayOfThisMonth{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *dateNow= [NSDate date];//获取到当前日期
    NSString * sDateNow = [formatter stringFromDate:dateNow];
    return sDateNow;
}

-(NSDate *)getFistDayINMonthframDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 指定日历单位，如日期和月份。(这里指定了年月日，还有其他字段添加单位.特别齐全 ：世纪，年月日时分秒等等等)
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // NSDateComponents封装了日期的组件,年月日时分秒等(个人感觉像是平时用的model模型)
    NSDateComponents *components = [calendar components: dayInfoUnits fromDate:date];
    // 指定1号
    components.day = 1;
    // 指定月份(我这里是获取当前月份的下1个月的1号的date对象,所以用的++，其上个月或者其他同理)
    //    components.month++；
    // 转成需要的date对象return
    NSDate * nextMonthDate =[calendar dateFromComponents:components];
    return nextMonthDate;
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
#pragma mark ------------------------------- 将汉字转化为拼音
+ (NSString *)transform:(NSString *)chinese{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
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

+(UILabel *)createLableFont:(UIFont *)font textColor:(UIColor *)textColor{
    return [NBTool createLableFont:font textColor:textColor textAlign:NSTextAlignmentLeft cornerrRaito:0];
}
+(UILabel *)createLableFont:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align cornerrRaito:(CGFloat)ratio{
    return [NBTool createLable:CGRectZero font:font textColor:textColor textAlign:align cornerrRaito:ratio];
}
+(UILabel *)createLable:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align cornerrRaito:(CGFloat)ratio{
    UILabel * lable = [[UILabel alloc]initWithFrame:frame];
    lable.font = font;
    lable.textColor = textColor;
    lable.textAlignment = align;
    if (ratio>0) {
        [lable nb_setAllCornerWithCornerRadius:ratio];
    }
    return lable;
}

/**
 *  获取最前端的KeyWindow 可能会有键盘所以的window
 */
+(UIWindow *)getForfontWindow{
    UIWindow * window;
    if (iOS11_Later) {
        return [UIApplication sharedApplication].keyWindow;
        
    }else{
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
    
    return [[NSMutableAttributedString alloc]initWithAttributedString:[NBTool getAttributedString:string font:size textColor:color]];
}
/**
 *  根据字符串生成可变富文本
 *  @param string 字符串内容
 *  @param size 字体尺寸
 *  @param color 字体颜色
 *  @return 可变富文本信息
 */
+(NSAttributedString *)getAttributedString:(NSString *)string font:(CGFloat)size textColor:(UIColor *)color{
    return [NBTool getAttributedString:string fontobj:[NBTool getFont:size] textColor:color];
}


+(NSAttributedString *)getAttributedString:(NSString *)string fontobj:(UIFont *)font textColor:(UIColor *)color{
    if ([NBTool isEmpty:string]) {
        string = @"";
    }
    NSAttributedString * atString = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName:color}];
    return atString;
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
+(void)openSetting{
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {//iOS >= 8.0
        if ([UIDevice currentDevice].systemVersion.floatValue<10.0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }
}



#pragma mark ------------------------------- keywindow显示提示信息
/**
 *  keyWindow展示提示信息
 *  @param message 提示信息
 */
+(void)showMessage:(NSString *)message
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow * window = NB_KEYWINDOW;
        UIView *showview =  [[UIView alloc]init];
        showview.tag = NB_Tag_ShowView;
        UIView * view = [window viewWithTag:NB_Tag_ShowView];
        if (view) {//移除原有的view可能会多层,所以移除
            [view removeFromSuperview];
            view = nil;
        }
        showview.backgroundColor = [UIColor getColorNumber:35];
        showview.alpha = 1.0f;
        showview.tag = NB_Tag_ShowView;
        [window addSubview:showview];
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        CGSize LabelSize = [NBTool autoString:message font:[NBTool getFont:15.f] width:NB_SCREEN_WIDTH - NB_Gap_40 height:NB_SCREEN_HEIGHT];
        
        
        label.frame = CGRectMake(NB_Gap_10, NB_Gap_10, LabelSize.width, LabelSize.height);
        label.text = message;
        label.textColor = [UIColor getColorNumber:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor =[UIColor getColorNumber:-1];
        label.font = [NBTool getFont:15.f];
        [showview addSubview:label];
        double time = 1.5 * (LabelSize.height/15.f);
        showview.frame = CGRectMake((NB_SCREEN_WIDTH - LabelSize.width - NB_Gap_20)/2.f,NB_SCREEN_HEIGHT- (LabelSize.height + NB_Gap_20)-100.f , LabelSize.width + NB_Gap_20, LabelSize.height + NB_Gap_20);
        [showview nb_setAllCornerWithCornerRadius:NB_Gap_03];
        [UIView animateWithDuration:1.5f delay:time options:UIViewAnimationOptionCurveLinear animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            if (showview) {
                [showview removeFromSuperview];
            }
        }];
    });
    
}


+(void)exitAppAnimated:(BOOL)animated{
    if (animated) {
        [UIView beginAnimations:@"exitApplication" context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:NB_KEYWINDOW cache:NO];
        [UIView setAnimationDidStopSelector:@selector(exitApp)];
        NB_KEYWINDOW.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        [UIView commitAnimations];
    }else{
        [NBTool exitApp];
    }
}
+(void)exitApp{
    exit(EXIT_SUCCESS);
}



@end
