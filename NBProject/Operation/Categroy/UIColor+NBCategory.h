//
//  UIColor+NBCategory.h
//  NBProject
//
//  Created by JayZhang on 2017/11/2.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NBCategory)

+ (UIColor *)getColorNumber:(NSInteger)num;
+ (UIColor *)getColorNumber:(NSInteger)num alph:(CGFloat)alp;

+ (UIColor *)colorWithHexValue:(NSUInteger) hexValue;
+ (UIColor *)colorWithHexValue:(NSUInteger) hexValue alpha:(CGFloat) alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)getColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alp;

@end
