//
//  UIView+NBCategory.h
//  wenzhong
//
//  Created by 峥刘 on 17/5/10.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NBCategory)

- (void)drawBezierCorner;//默认为10,倒全角

/**倒角全部**/
- (void)drawBezierCornerWithRatio:(CGFloat)ratio;

/**倒角上部**/
- (void)drawBezierTopCornerWithRatio:(CGFloat)ratio;

/**倒角左部**/
- (void)drawBezierLeftCornerWithRatio:(CGFloat)ratio;

/**倒角下部**/
- (void)drawBezierBottomCornerWithRatio:(CGFloat)ratio;

/**倒角右部**/
- (void)drawBezierRightCornerWithRatio:(CGFloat)ratio;



- (void)drawgradientLayer;

/*将view转化为图片*/
-(UIImage *)shot;
//添加高斯模糊
-(void)blurEffect;
//移除高斯模糊
-(void)removeBlurEffect;

@end
