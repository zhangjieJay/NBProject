//
//  NBSliderView.h
//  OptionView
//
//  Created by 张杰 on 2017/5/16.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NBSliderViewDelegate <NSObject>

@optional

- (void)sliderViewDidClickedButton:(UIButton *)sender atIndex:(NSInteger)index;

@end

@interface NBSliderView : UIView



@property(nonatomic,assign)id<NBSliderViewDelegate>sliderDelegate;

@property(nonatomic,copy)NSArray * arTitle;//此属性设置会初始化界面的控件

//滚动到制定的索引
- (void)scrollToindex:(NSInteger)index;


@property(nonatomic,readonly)NSInteger currentIndex;
@property(nonatomic,assign)BOOL isAverage;//按钮是否平均分配 default YES
@property(nonatomic,assign)BOOL showLine;//显示滑动条 default YES



@end
