//
//  NBGifHeader.h
//  NBProject
//
//  Created by 张杰 on 2018/1/24.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBRefreshHeader.h"

@interface NBGifHeader : NBRefreshHeader

@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(NBRefreshState)state;
- (void)setImages:(NSArray *)images forState:(NBRefreshState)state;
@end
