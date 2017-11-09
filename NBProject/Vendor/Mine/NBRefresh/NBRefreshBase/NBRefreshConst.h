//
//  NBRefreshConst.h
//  NBProject
//
//  Created by JayZhang on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define NBWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define NBRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define NBRefreshLog(...)
#endif

// 过期提醒
#define NBRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define NBRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define NBRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define NBRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define NBRefreshLabelTextColor NBRefreshColor(90, 90, 90)

// 字体大小
#define NBRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
UIKIT_EXTERN const CGFloat NBRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat NBRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat NBRefreshFooterHeight;
UIKIT_EXTERN const CGFloat NBRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat NBRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const NBRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const NBRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const NBRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const NBRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const NBRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const NBRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const NBRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const NBRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const NBRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const NBRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const NBRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const NBRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const NBRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const NBRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const NBRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const NBRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const NBRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const NBRefreshHeaderNoneLastDateText;

// 状态检查
#define NBRefreshCheckState \
NBRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
