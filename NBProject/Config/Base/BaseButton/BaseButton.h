//
//  BaseButton.h
//  wenzhong
//
//  Created by JayZhang on 17/3/23.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseButton : UIButton

@property(nonatomic,assign)NBButtonType nb_titleType;
/*
 *从左到右或者从上到下 两个控件的比例.左右则为宽度比  上下则为高度比
 */
@property(nonatomic,assign)CGFloat nb_scale;


@end
