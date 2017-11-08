//
//  NBRefreshStateFooter.h
//  NBProject
//
//  Created by scuser on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshAutoFooter.h"

@interface NBRefreshStateFooter : NBRefreshAutoFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(NBRefreshState)state;

/** 隐藏刷新状态的文字 */
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end
