//
//  NBQRCodeTool.h
//  LivingMuseumMF
//
//  Created by Jay on 17/5/8.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBQRCodeTool : NSObject


/** 生成一张普通的二维码 图片默认尺寸200 * 200 pix 默认颜色黑色*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData;

/** 生成一张指定图片尺寸的二维码 默认颜色黑色*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData
                                  imageWidth:(CGFloat)Imagewidth;

/** 生成一张指定颜色的二维码 图片默认尺寸200 * 200 pix*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData
                                         red:(CGFloat)red
                                       green:(CGFloat)green
                                        blue:(CGFloat)blue;

/** 生成一张指定颜色指定尺寸的二维码*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData
                                  imageWidth:(CGFloat)Imagewidth
                                         red:(CGFloat)red
                                       green:(CGFloat)green
                                        blue:(CGFloat)blue;



/** 生成一张带logo的二维码 默认颜色黑色,二维码默认尺寸200 * 200 pix logo默认比例长宽为图片的0.2*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData
                            logoImageName:(NSString *)logoName;

/** 生成一张带指定尺寸logo的二维码 默认颜色黑色,logo默认比例长宽为图片的0.2*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData
                               imageWidth:(CGFloat)Imagewidth
                            logoImageName:(NSString *)logoName;

/** 生成一张带指定尺寸、指定比例logo的二维码 默认颜色黑色*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData
                               imageWidth:(CGFloat)Imagewidth
                            logoImageName:(NSString *)logoName
                                logoScale:(CGFloat)scale;

/** 生成一张带指定尺寸、指定比例logo、指定颜色的二维码*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData
                               imageWidth:(CGFloat)Imagewidth
                            logoImageName:(NSString *)logoName
                                logoScale:(CGFloat)scale
                                      red:(CGFloat)red
                                    green:(CGFloat)green
                                     blue:(CGFloat)blue;
@end
