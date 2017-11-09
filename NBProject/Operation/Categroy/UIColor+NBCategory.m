//
//  UIColor+NBCategory.m
//  NBProject
//
//  Created by JayZhang on 2017/11/2.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIColor+NBCategory.h"

@implementation UIColor (NBCategory)
#pragma mark -------------------------------------------------------- 16进制获取颜色参数NSInteger
+(UIColor *)colorWithHexValue:(NSUInteger) hexValue{
    
    return  [UIColor colorWithHexValue:hexValue alpha:1];
}

+ (UIColor *)colorWithHexValue:(NSUInteger) hexValue alpha:(CGFloat) alpha {
    return [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16) / 255.0 green:((hexValue & 0xFF00) >> 8) / 255.0 blue:(hexValue & 0xFF) / 255.0 alpha:alpha];
}


#pragma mark -------------------------------------------------------- 16进制获取颜色参数字符串
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)color{
    
    return [UIColor colorWithHexString:color alpha:1];
}

#pragma mark -------------------------------------------------------- 获取一个颜色
/**
 *  根据自定义序号和透明度生成颜色(此方法中可以自定义颜色,规定对应序号)
 *  @param num 自定义的序号
 *  @return 目标颜色(默认为不透明)
 */
+ (UIColor *)getColorNumber:(NSInteger)num
{
    return [UIColor getColorNumber:num alph:1.f];
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
    return [UIColor getColorWithRed:red green:gre blue:blu alpha:alp];
}
#pragma mark ------------------------------------ 生成一种颜色
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
@end
