//
//  NBRefreshConst.h
//  NBProject
//
//  Created by 张杰 on 2018/1/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

// RGB颜色
#define NBRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define NBRefreshLabelTextColor NBRefreshColor(90, 90, 90)
// 字体大小
#define NBRefreshLabelFont [UIFont boldSystemFontOfSize:14]

//header 默认高度
UIKIT_EXTERN const CGFloat NBRefreshHeaderHeight;

//endrefresh 时动画执行之间
UIKIT_EXTERN const CGFloat NBRefreshSlowAnimationDuration;

//startrefresh 时动画执行之间
UIKIT_EXTERN const CGFloat NBRefreshFastAnimationDuration;

//偏移量变化 keyPath
UIKIT_EXTERN NSString *const NBRefreshKeyPathContentOffset;



#define NBCheckState \
NBRefreshState oldState = self.state;\
if (state == oldState) return;\
[super setState:state];\
