//
//  UIView+NBCategory.m
//  wenzhong
//
//  Created by JayZhang on 17/5/10.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIView+NBCategory.h"

@implementation UIView (NBCategory)




- (void)drawBezierCorner{
    
    [self drawBezierCornerWithRatio:self.bounds.size.height/2.f];

}

- (void)drawBezierCornerWithRatio:(CGFloat)ratio{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(ratio, ratio)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    maskLayer.masksToBounds = YES;
    self.layer.mask = maskLayer;
}





#pragma mark -------------------------------------------------------- 绘制渐变色
- (void)drawgradientLayer{

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor];
    gradientLayer.mask = self.layer;

}


#pragma mark ------------------------------ 倒上面角
- (void)drawBezierTopCornerWithRatio:(CGFloat)ratio{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(ratio, ratio)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
#pragma mark ------------------------------ 倒左边角
- (void)drawBezierLeftCornerWithRatio:(CGFloat)ratio{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(ratio, ratio)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
#pragma mark ------------------------------ 倒下面角
- (void)drawBezierBottomCornerWithRatio:(CGFloat)ratio{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(ratio, ratio)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
#pragma mark ------------------------------ 倒右边角
- (void)drawBezierRightCornerWithRatio:(CGFloat)ratio{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(ratio, ratio)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/*UIView截取图片*/
-(UIImage *)shot{
    
    UIGraphicsBeginImageContext(self.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];//将layer绘制到画布中
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//获取当前画布的
    UIGraphicsEndImageContext();//结束
    return image;
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);//把图片保存在本地
}

/**
 *  增加模糊效果(和removeBlurEffect配合使用)
 *
 */
-(void)blurEffect{
    
    
    UIView * view = [self viewWithTag:NB_Tag_BlurView];//获取对应的高斯模糊控件,是否存在
    
    if (view) {//存在高斯模糊视图

    }else{//不存在则创建
    
        if (iOS8_Later) {//如果大于=iOS 8.0
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];//创建模糊效果
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];//创建模糊效果的视图
            effectView.tag = NB_Tag_BlurView;
            effectView.frame = self.bounds;//设置frame
            [self addSubview:effectView];//添加
        }else{//如果小于iOS 8.0
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
            toolbar.tag = NB_Tag_BlurView;
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            [self addSubview:toolbar];
        }
    }

    

}

/**
 *  移除模糊效果
 *
 */
-(void)removeBlurEffect{
    UIView * view = [self viewWithTag:NB_Tag_BlurView];
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
}




@end
