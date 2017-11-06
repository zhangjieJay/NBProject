//
//  NBQRCodeTool.m
//  LivingMuseumMF
//
//  Created by Jay on 17/5/8.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBQRCodeTool.h"



@implementation NBQRCodeTool


/** 生成一张普通的二维码 图片默认尺寸200 * 200 pix 默认颜色黑色*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData
{
    return [NBQRCodeTool generateWithDefaultQRCodeData:sData imageWidth:200 red:0 green:0 blue:0];
}

/** 生成一张指定图片尺寸的二维码 默认颜色黑色*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData imageWidth:(CGFloat)Imagewidth
{
 return [NBQRCodeTool generateWithDefaultQRCodeData:sData imageWidth:Imagewidth red:0 green:0 blue:0];
}

/** 生成一张指定颜色的二维码 图片默认尺寸200 * 200 pix*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [NBQRCodeTool generateWithDefaultQRCodeData:sData imageWidth:200 red:red green:green blue:blue];
}

#pragma mark --------------------- 生成普通二维码图片
/** 生成一张指定颜色指定尺寸的二维码*/
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)sData
                                imageWidth:(CGFloat)Imagewidth
                                       red:(CGFloat)red
                                     green:(CGFloat)green
                                      blue:(CGFloat)blue
{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = sData;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 设置纠错级别
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];

    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 4、调整尺寸
    UIImage * scaleImage = [NBQRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:Imagewidth];
    
    // 5、上色
    return [NBQRCodeTool imageBlackToTransParent:scaleImage withRed:red andGreen:green andBlue:blue];

}


#pragma mark --------------------- 根据CIImage生成指定大小的UIImage
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage * imageUI = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return imageUI;
}



void ProviderReleaseData (void *info,const void *data,size_t size) {
    free((void *)data);
}

#pragma mark --------------------- 给二维码上色
+ (UIImage *)imageBlackToTransParent:(UIImage *)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    //
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);



    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


/** 生成一张带logo的二维码 默认颜色黑色,二维码默认尺寸200 * 200 pix logo默认比例长宽为图片的0.2*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData logoImageName:(NSString *)logoName{


    return [NBQRCodeTool generateWithLogoQRCodeData:sData imageWidth:200 logoImageName:logoName logoScale:0.2];
}


/** 生成一张带指定尺寸logo的二维码 默认颜色黑色,logo默认比例长宽为图片的0.2*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData imageWidth:(CGFloat)Imagewidth logoImageName:(NSString *)logoName
{

    return [NBQRCodeTool generateWithLogoQRCodeData:sData imageWidth:Imagewidth logoImageName:logoName logoScale:0.2];

}
/** 生成一张带指定尺寸、指定比例logo的二维码 默认颜色黑色*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData
                               imageWidth:(CGFloat)Imagewidth
                            logoImageName:(NSString *)logoName
                                logoScale:(CGFloat)scale{

    return [NBQRCodeTool generateWithLogoQRCodeData:sData imageWidth:Imagewidth logoImageName:logoName logoScale:scale red:0 green:0 blue:0];

}

#pragma mark --------------------- 生成一张带Logo的二维码
/** 生成一张带指定尺寸、指定比例logo、指定颜色的二维码*/
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)sData
                               imageWidth:(CGFloat)Imagewidth
                            logoImageName:(NSString *)logoName
                                logoScale:(CGFloat)scale
                                      red:(CGFloat)red
                                    green:(CGFloat)green
                                     blue:(CGFloat)blue{


    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = sData;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 4、将CIImage类型转成UIImage类型,指定尺寸
    UIImage *scale_image = [NBQRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:Imagewidth];
    
    // 5、改变颜色
    UIImage *start_image = [NBQRCodeTool imageBlackToTransParent:scale_image withRed:red andGreen:green andBlue:blue];
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 6、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 7、把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 8、把小图片画上去
    NSString *icon_imageName = logoName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * scale;
    CGFloat icon_imageH = start_image.size.height * scale;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 9、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 10、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;


}

#pragma mark --------------------- 参考方法,暂时未用到
/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImageName    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}

@end
