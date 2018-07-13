//
//  UIImageView+NB.h
//  NBProject
//
//  Created by 张杰 on 2018/5/29.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NB)
#pragma mark ------------------------------------ 给图片添加倒影
-(void)addInvertedReflection;

#pragma mark ------------------------------------  画水印
- (void) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;
@end
