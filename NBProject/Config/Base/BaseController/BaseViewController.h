//
//  BaseViewController.h
//  wenzhong
//
//  Created by JayZhang on 17/3/21.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIScrollViewDelegate>
/**
 ** 当前视图中包含滚动视图的偏移量,用来控制导航栏是否透明的问题,导航栏透明,初始frame为0是情况使用
 **/
@property(nonatomic,assign)CGFloat currentOffset;

@property(nonatomic,assign,getter=isSticked)BOOL sticked;//是否置顶 及不自动便宜64

@property(nonatomic,strong)UIColor * normarlNavigationColor;//正常情况下颜色
@property(nonatomic,strong)UIColor * effectNavigationColor;//正常情况下颜色



-(void)initNavigation;
-(void)hideNavigationSeperator;//导航栏底部分割线
-(void)showNavigationSeperator;//导航栏底部分割线
-(void)asignSeparatorColor:(UIColor *)color;
-(void)enabledTranslucentBackground;
-(void)unabledTranslucentBackground;
@property(nonatomic,assign,getter=isScrollNavigationlEffectEnabled)BOOL scrollNavigationlEffectEnabled;//是否子视图滚动时导航栏

@end
