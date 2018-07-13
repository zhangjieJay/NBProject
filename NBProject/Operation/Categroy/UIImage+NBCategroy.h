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
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
#pragma mark ------------------------------------ 获得灰度图
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;
#pragma mark ------------------------------------ 合并两个图片
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

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

- (NSData *)compressDataMaxKB:(NSInteger)kbValue;
//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data;
//将突破裁剪为一张圆形图片
- (UIImage *)clipToCircleImage;
//图片是否有透明通道
- (BOOL)hasAlphaChannel;

@end
