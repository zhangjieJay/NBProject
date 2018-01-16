//
//  UIControl+NBClicked.h
//  NBProject
//
//  Created by 张杰 on 2018/1/11.
//  Copyright © 2018年 Jay. All rights reserved.
//

/**
 *此类别主要是控制重复点击事件  控制连续点击的时间间隔
 **/

#import <UIKit/UIKit.h>

@interface UIControl (NBClicked)
@property(nonatomic,assign)NSTimeInterval nb_clickedInterval;// 可以用这个给重复点击加间隔
@end
