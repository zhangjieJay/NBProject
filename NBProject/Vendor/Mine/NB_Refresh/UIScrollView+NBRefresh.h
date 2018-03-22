//
//  UIScrollView+NBRefresh.h
//  NBProject
//
//  Created by JayZhang on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBRefreshHeader.h"

//@class NBRefreshHeader, NBRefreshFooter;

@interface UIScrollView (NBRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic) NBRefreshHeader * nb_header;


@end
