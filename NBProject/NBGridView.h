//
//  NBGridView.h
//  NBProject
//
//  Created by 张杰 on 2018/7/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseView.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

@interface NBGridView : BaseView
/**
 * @brief 网格间距，默认30
 */
@property (nonatomic, assign) CGFloat   gridWidth;

/**
 * @brief 网格间距，默认30
 */
@property (nonatomic, assign) CGFloat   gridHeight;


/**
 * @brief 网格线宽度，默认为1 pixel (1.0f / [UIScreen mainScreen].scale)
 */
@property (nonatomic, assign) CGFloat   gridLineWidth;
/**
 * @brief 网格颜色，默认蓝色
 */
@property (nonatomic, strong) UIColor   *gridColor;


//NBGridView *gridView = [[NBGridView alloc] initWithFrame:self.view.bounds];
//gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//gridView.alpha = 0.6;
//gridView.gridColor = [UIColor blackColor];
//[self.view addSubview:gridView];

@end
