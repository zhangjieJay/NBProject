//
//  UIImage+NBCategroy.h
//  wenzhong
//
//  Created by JayZhang on 17/5/9.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NBCategroy)



+ (UIImage *)imageWithColor:(UIColor *)color;


+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;//在当前图片上绘制文字

//生成一张在原来图片带模糊效果的图片
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

#pragma mark ----------------------采用CoreImage 高斯模糊图片
- (UIImage *)blurryByVImageWithBlurLevel:(CGFloat)blur;
- (UIImage *)blurryByCoreImageWithBlurLevel:(CGFloat)blur;
//裁剪图片到指定尺寸,但会裁剪成正方形
- (UIImage *)thumbnailToSize:(CGSize)asize;
- (UIImage *)thumbnailToSize:(CGSize)asize rect:(BOOL)isRect;

- (UIImage *)fixOrientation;
@end
