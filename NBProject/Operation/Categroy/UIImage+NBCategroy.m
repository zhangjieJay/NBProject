//
//  UIImage+NBCategroy.m
//  wenzhong
//
//  Created by 峥刘 on 17/5/9.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIImage+NBCategroy.h"
#import <Accelerate/Accelerate.h>


@implementation UIImage (NBCategroy)


//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}






- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize
{
    
    //画布大小
    CGSize size = CGSizeMake(self.size.width,self.size.height);
    
    
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    
    //计算文字所占的size,文字居中显示在画布上
//    CGSize sizeText = [NBTool autoSizeWithString:title font:[NBTool getFont:fontSize] width:size.width];
    
    
    
    CGSize sizeText = [NBTool autoString:title font:[NBTool getFont:fontSize] width:size.width];

    CGFloat width = self.size.width;
    
    CGFloat height = self.size.height;
    
    
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    
    //绘制文字
    
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor grayColor],NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    
    //convert to ARGB if it isn't
    if (CGImageGetBitsPerPixel(imageRef) != 32 ||
        CGImageGetBitsPerComponent(imageRef) != 8 ||
        !((CGImageGetBitmapInfo(imageRef) & kCGBitmapAlphaInfoMask)))
    {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawAtPoint:CGPointZero];
        imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndImageContext();
    }
    
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}



/**
 *  使用vImage API进行 高斯模糊图片返回处理后的图片
 *  @param blur 模糊成都
 *  @return 处理后的图片
 */
- (UIImage *)blurryByVImageWithBlurLevel:(CGFloat)blur{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data, 
                                             outBuffer.width, 
                                             outBuffer.height, 
                                             8, 
                                             outBuffer.rowBytes, 
                                             colorSpace, 
                                             kCGImageAlphaNoneSkipLast); 
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx); 
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef]; 
    //clean up 
    CGContextRelease(ctx); 
    CGColorSpaceRelease(colorSpace); 
    free(pixelBuffer); 
    CFRelease(inBitmapData); 
    CGColorSpaceRelease(colorSpace); 
    CGImageRelease(imageRef); 
    return returnImage;
}


/**
 *  采用core image 高斯模糊图片返回处理后的图片(暂时存在问题)
 *  @param blur 模糊系数
 *  @return 处理后的图片
 */
- (UIImage *)blurryByCoreImageWithBlurLevel:(CGFloat)blur{
    
    //    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBlur];//blur全部name
    CIImage *ciimage = [CIImage imageWithCGImage:self.CGImage];// 将图片转换为Core Image
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, ciimage, @"inputRadius", @(blur), nil];//生成滤镜
    ////或者
    //    CIFilter * filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //    [filter setValue:ciimage forKey:kCIInputImageKey];
    //    [filter setValue:[NSNumber numberWithFloat:blur] forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = filter.outputImage;//获取滤镜过滤后的图片[filter valueForKey:kCIOutputImageKey];

    
    CIContext *ciContext = [CIContext contextWithOptions:nil];//core image context
    CGImageRef outImage = [ciContext createCGImage:outputImage fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}





@end
