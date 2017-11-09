//
//  ImageModel.h
//  NBProject
//
//  Created by JayZhang on 17/8/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

/**
 *  此类主要是提供图片预览模型的构造,默认为本地图片即 NBImageSourceType_name,网络地址为 NBImageSourceType_url
 */


#import "BaseModel.h"

@interface ImageModel : BaseModel

PROPERTY_NSSTRING(imageName);//图片名称
PROPERTY_NSSTRING(imageUrl);//图片链接

@property(nonatomic,assign)NBImageSourceType type;//图片类型

@end
