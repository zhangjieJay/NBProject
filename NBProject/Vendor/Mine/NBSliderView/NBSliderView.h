//
//  NBSliderView.h
//  OptionView
//
//  Created by 张杰 on 2017/5/16.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

/**
 *  常用可滑动按钮组视图 如订单状态等视图运用
 *
 */

#import <UIKit/UIKit.h>
@class NBSliderView;

@protocol NBSliderViewDelegate <NSObject>

@optional

- (void)sliderView:(NBSliderView *)sliderView didClickedButton:(UIButton *)sender atIndex:(NSInteger)index;

@end

@interface NBSliderView : UIView



@property(nonatomic,weak)id<NBSliderViewDelegate>nbsv_delegate;

@property(nonatomic,copy)NSArray * arTitle;//此属性设置会初始化界面的控件

//滚动到制定的索引
- (void)scrollToindex:(NSInteger)index;


@property(nonatomic,readonly)NSInteger currentIndex;
@property(nonatomic,assign)BOOL isAverage;//按钮是否平均分配 default YES
@property(nonatomic,assign)BOOL showBar;//显示滑动条 default YES

@property(nonatomic,assign)BOOL showLine;//显示分割线 default YES


@property(nonatomic,strong)UIColor * barColor;//滚动条颜色
@property(nonatomic,assign)CGFloat barHeight;//滚动条高度 默认2

@property(nonatomic,strong)UIColor * titleSeleColor;//标题选中颜色
@property(nonatomic,strong)UIColor * titleDeseleColor;//标题未选中颜色
@property(nonatomic,strong)UIFont * titleFont;//标题字体大小
@property(nonatomic,assign)CGFloat  btnWidthOffset;//此属性为根据标题计算长度后按钮增加的宽度,默认为20.f

@property(nonatomic,assign)CGFloat edgeGap;//边缘空隙默认为10.f;
@property(nonatomic,assign)CGFloat midGap;//中间空隙默认为10.f;
@property(nonatomic,assign)BOOL isAutoScroll;//是否自动滚动



@end
