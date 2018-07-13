//
//  UIView+NBCategory.m
//  wenzhong
//
//  Created by JayZhang on 17/5/10.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIView+NBCategory.h"
#import <objc/runtime.h>

static NSString * const NBCornerPositionKey = @"NBCornerPositionKey";
static NSString * const NBCornerRadiusKey = @"NBCornerRadiusKey";
static NSString * const NBBorderColorKey = @"NBCornerBorderColorKey";
static NSString * const NBBorderWidthKey = @"NBCornerBorderWidthKey";


@implementation UIView (NBCategory)


@dynamic nb_cornerPosition;
@dynamic nb_cornerRadius;

-(NBCornerPosition)nb_cornerPosition{
    return [objc_getAssociatedObject(self, &NBCornerPositionKey) integerValue];
}
-(void)setNb_cornerPosition:(NBCornerPosition)nb_cornerPosition{
    objc_setAssociatedObject(self, &NBCornerPositionKey, @(nb_cornerPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)nb_cornerRadius{
    return [objc_getAssociatedObject(self, &NBCornerRadiusKey) floatValue];
}
- (void)setNb_cornerRadius:(CGFloat)nb_cornerRadius{
    objc_setAssociatedObject(self, &NBCornerRadiusKey, @(nb_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)nb_borderColor{
    return objc_getAssociatedObject(self, &NBBorderColorKey);
}
-(void)setNb_borderColor:(UIColor *)nb_borderColor{
    objc_setAssociatedObject(self, &NBBorderColorKey, nb_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)nb_borderWidth{
    return [objc_getAssociatedObject(self, &NBBorderWidthKey) floatValue];
}
- (void)setNb_borderWidth:(CGFloat)nb_borderWidth{
    objc_setAssociatedObject(self, &NBBorderWidthKey, @(nb_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+(void)load{
    SEL originalSel = @selector(layoutSublayersOfLayer:);
    SEL swizzleSel = NSSelectorFromString([@"nb_" stringByAppendingString:NSStringFromSelector(originalSel)]);
    nb_swizzle(self, originalSel, swizzleSel);
}

void nb_swizzle(Class class,SEL ori,SEL swi){
    Method origMethod = class_getInstanceMethod(class, ori);
    Method newMethod = class_getInstanceMethod(class, swi);
    method_exchangeImplementations(origMethod, newMethod);
}
-(void)nb_layoutSublayersOfLayer:(CALayer *)layer{
    
    
    [self nb_layoutSublayersOfLayer:layer];
    
    if (self.nb_cornerRadius > 0) {
        UIGraphicsBeginImageContext(self.bounds.size);

        UIBezierPath *maskPath;
        switch (self.nb_cornerPosition) {
            case NBCornerPosition_Top:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                       cornerRadii:CGSizeMake(self.nb_cornerRadius, self.nb_cornerRadius)];
                break;
            case NBCornerPosition_Left:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                       cornerRadii:CGSizeMake(self.nb_cornerRadius, self.nb_cornerRadius)];
                break;
            case NBCornerPosition_Bottom:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                       cornerRadii:CGSizeMake(self.nb_cornerRadius, self.nb_cornerRadius)];
                break;
            case NBCornerPosition_Right:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                                       cornerRadii:CGSizeMake(self.nb_cornerRadius, self.nb_cornerRadius)];
                break;
            case NBCornerPosition_All:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:UIRectCornerAllCorners
                                                       cornerRadii:CGSizeMake(self.nb_cornerRadius, self.nb_cornerRadius)];
                break;
            case NBCornerPosition_AllRound:{
                CGFloat ratio = MIN(self.bounds.size.width,self.bounds.size.height);
                
                
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:UIRectCornerAllCorners
                                                       cornerRadii:CGSizeMake(ratio/2.f, ratio/2.f)];
                break;
            }
            default:
                break;
        }
        if (maskPath) {
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
            if (self.nb_borderWidth >0) {
                CAShapeLayer *borderLayer = [CAShapeLayer layer];
                borderLayer.path    =   maskPath.CGPath;
                borderLayer.fillColor  = [UIColor clearColor].CGColor;
                borderLayer.strokeColor    = self.nb_borderColor.CGColor;
                borderLayer.lineWidth      = self.nb_borderWidth;
                borderLayer.frame = self.bounds;
                [self.layer addSublayer:borderLayer];
            }
        }
        
        
        UIGraphicsEndImageContext();

    }
}

- (void)nb_setCornerOnTopWithRadius:(CGFloat)radius
{
    self.nb_cornerPosition = NBCornerPosition_Top;
    self.nb_cornerRadius = radius;
}

- (void)nb_setCornerOnLeftWithRadius:(CGFloat)radius
{
    self.nb_cornerPosition = NBCornerPosition_Left;
    self.nb_cornerRadius = radius;
}

- (void)nb_setCornerOnBottomWithRadius:(CGFloat)radius
{
    self.nb_cornerPosition = NBCornerPosition_Bottom;
    self.nb_cornerRadius = radius;
}

- (void)nb_setCornerOnRightWithRadius:(CGFloat)radius
{
    self.nb_cornerPosition = NBCornerPosition_Right;
    self.nb_cornerRadius = radius;
}

- (void)nb_setAllCornerWithCornerRadius:(CGFloat)radius
{
    self.nb_cornerPosition = NBCornerPosition_All;
    self.nb_cornerRadius = radius;
}
- (void)nb_setAllCornerRound{
    self.nb_cornerPosition = NBCornerPosition_AllRound;
    self.nb_cornerRadius = 1;

}

- (void)nb_setNoneCorner
{
    self.layer.mask = nil;
}









#pragma mark -------------------------------------------------------- 绘制渐变色


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
-(CGRect)convertToWindow{
    CGRect  rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].windows.lastObject];
    return rect;
}

- (UIViewController *)responseController{
    
    UIResponder * responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return  nil;
}

@end
