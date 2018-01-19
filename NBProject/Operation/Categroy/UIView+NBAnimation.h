//
//  UIView+NBAnimation.h
//  YJAutoProject
//
//  Created by 张杰 on 2017/4/29.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NBAnimation)<CAAnimationDelegate>


- (void)animateWithDuration:(NSTimeInterval)duration fromScale:(CGFloat)fScale toScale:(CGFloat)tScale;
- (void)animateWithDuration:(NSTimeInterval)duration fromPositionX:(CGFloat)fpx toPositionX:(CGFloat)tpx;
- (void)animateWithDuration:(NSTimeInterval)duration fromPositionY:(CGFloat)fpy toPositionY:(CGFloat)tpy;

/**加载的动画1**/
- (void)animateCircleRotation;
/**加载的动画2**/
- (void)animateDashCircleRotation;

/*抛物线动画,如加入购物车*/
-(void)throwToView:(UIView *)target;
@end
