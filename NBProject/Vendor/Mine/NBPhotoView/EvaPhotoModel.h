//
//  EvaPhotoModel.h
//  baitong_ios
//
//  Created by scuser on 2017/10/7.
//  Copyright © 2017年 syyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaPhotoModel : NSObject
@property(nonatomic,strong)UIImage * imageOriginal;//原图
@property(nonatomic,strong)UIImage * imageScaled;//缩略图
@property(nonatomic,copy)NSString * imagePath;//图片路径
@property(nonatomic,assign)NSInteger row;//序号
@property(nonatomic,assign)BOOL isAdd;//默认添加图片
@property(nonatomic,assign)BOOL hideX;//是否显示x
@property(nonatomic,assign)BOOL addNew;//是否有新增图片

@end
