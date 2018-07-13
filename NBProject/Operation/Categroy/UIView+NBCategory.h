//
//  UIView+NBCategory.h
//  wenzhong
//
//  Created by JayZhang on 17/5/10.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NBCategory)

@property (nonatomic, assign) NBCornerPosition nb_cornerPosition;
@property (nonatomic, assign) CGFloat nb_cornerRadius;

@property(nonatomic,strong)UIColor * nb_borderColor;//倒角的颜色
@property(nonatomic,assign)CGFloat nb_borderWidth;//倒角的宽度


/**倒角上边全部**/
- (void)nb_setCornerOnTopWithRadius:(CGFloat)radius;
/**倒角左边全部**/
- (void)nb_setCornerOnLeftWithRadius:(CGFloat)radius;
/**倒角下边全部**/
- (void)nb_setCornerOnBottomWithRadius:(CGFloat)radius;
/**倒角右边全部**/
- (void)nb_setCornerOnRightWithRadius:(CGFloat)radius;
/**倒角全部**/
- (void)nb_setAllCornerWithCornerRadius:(CGFloat)radius;
- (void)nb_setAllCornerRound;//倒角为圆形
/**不设置角**/
- (void)nb_setNoneCorner;


- (void)drawgradientLayer;
/*将view转化为图片*/
-(UIImage *)shot;
//添加高斯模糊
-(void)blurEffect;
//移除高斯模糊
-(void)removeBlurEffect;
-(CGRect)convertToWindow;
//当前视图所在控制器
- (UIViewController *)responseController;
@end
