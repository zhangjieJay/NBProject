//
//  NBStoreManager.h
//  NBProject
//
//  Created by 张杰 on 2018/1/5.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBStoreManager : NSObject

+(instancetype)manager;

#pragma mark ------------------------------------ 存入沙箱中的文件夹里面
+(void)encodeObject:(id)obj forPath:(NSString *)path fileName:(NSString *)name;
#pragma mark ------------------------------------ 存入沙箱中的默认文件夹文件夹里面
+(void)encodeObject:(id)obj fileName:(NSString *)name;
#pragma mark ------------------------------------ 直接存入UserDefault中
+(void)encodeObject:(id)obj forKey:(NSString *)key;

#pragma mark ------------------------------------ 获取数据
+(id)decodeForKey:(NSString *)key;
+(id)decodeFileName:(NSString *)name;
+(id)decodeForPath:(NSString *)path fileName:(NSString *)name;
+(void)clearCodeCache;


@end
