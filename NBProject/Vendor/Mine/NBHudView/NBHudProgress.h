//
//  NBHudView.h
//  YJAutoProject
//
//  Created by 张杰 on 2017/4/28.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBHudProgress : NSObject

/**显示加载用在KeyWindow**/
+ (void)show;
+ (void)showText:(NSString *)text;
//+ (void)showTopText:(NSString *)text;
//+ (void)showCenterText:(NSString *)text;


/**显示加载用在目标view上**/
+ (void)showInView:(UIView *)view;
+ (void)showInView:(UIView *)view text:(NSString *)text;


/**提示成功**/
+ (void)showSuccessText:(NSString *)text;
+ (void)showSuccessText:(NSString *)text inView:(UIView *)view;


/**提示失败**/
+ (void)showErrorText:(NSString *)text;
+ (void)showErrorText:(NSString *)text inView:(UIView *)view;




/**消失**/
+ (void)disMiss;
@end
