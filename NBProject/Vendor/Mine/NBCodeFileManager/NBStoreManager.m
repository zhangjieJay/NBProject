//
//  NBStoreManager.m
//  NBProject
//
//  Created by 张杰 on 2018/1/5.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBStoreManager.h"

@implementation NBStoreManager
#pragma mark ------------------------------------ 直接存入UserDefault中
+(void)encodeObject:(id)obj forKey:(NSString *)key{
    
    //保存对象转化为二进制数据（一定是可变对象）
    NSMutableData *data = [NSMutableData data];
    //1.初始化
    NSKeyedArchiver *archivier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //2.归档
    [archivier encodeObject:obj forKey:key];
    //3.完成归档
    [archivier finishEncoding];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
    
}
#pragma mark ------------------------------------ 存入沙箱中的默认文件夹文件夹里面
+(void)encodeObject:(id)obj fileName:(NSString *)name{
    [NBStoreManager encodeObject:obj forPath:NB_Code_File fileName:name];
}

#pragma mark ------------------------------------ 存入沙箱中的文件夹里面
+(void)encodeObject:(id)obj forPath:(NSString *)path fileName:(NSString *)name{

    if (obj) {
        //保存对象转化为二进制数据（一定是可变对象）
        NSMutableData *data = [NSMutableData data];
        //1.初始化
        NSKeyedArchiver *archivier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        //2.归档
        [archivier encodeObject:obj forKey:[NBTool MD5String:name]];
        //3.完成归档
        [archivier finishEncoding];
        //4.获取沙箱library路径
        NSString * pathLi = [NBTool getSandBoxLibraryPath];
        //获取要放置文件的路径
        NSString * destPath = [pathLi stringByAppendingPathComponent:path];
    
        NSFileManager * fileManager = [NSFileManager defaultManager];
        //看目标文件在是否存在
        if (![fileManager fileExistsAtPath:destPath]) {
            [fileManager createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString * fileName = [destPath stringByAppendingPathComponent:[NBTool MD5String:name]];
        [fileManager createFileAtPath:fileName contents:data attributes:nil];
    }
}

#pragma mark ------------------------------------ 获取数据

+(id)decodeForKey:(NSString *)key{
        //1.获取保存的数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data.length >0) {
        //2.初始化解归档对象
        NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //3.解归档
        id obj = [unarchiver decodeObjectForKey:key];
        //4.完成解归档
        [unarchiver finishDecoding];
        return obj;
    }else{
        return nil;
    }

}


+(id)decodeFileName:(NSString *)name{
    
    return [NBStoreManager decodeForPath:NB_Code_File fileName:name];
}

+(id)decodeForPath:(NSString *)path fileName:(NSString *)name{
    
    //4.获取沙箱library路径
    NSString * pathLi = [NBTool getSandBoxLibraryPath];
    //获取要放置文件的路径
    NSString * destPath = [pathLi stringByAppendingPathComponent:path];
    NSString * fileName = [destPath stringByAppendingPathComponent:[NBTool MD5String:name]];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
        //1.获取保存的数据
        NSData * data = [NSData dataWithContentsOfFile:fileName];
        //2.初始化解归档对象
        NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //3.解归档
        id obj = [unarchiver decodeObjectForKey:[NBTool MD5String:name]];
        //4.完成解归档
        [unarchiver finishDecoding];
        return obj;
    }
    return nil;
}

+(void)clearCodeCache{
    [NBStoreManager clearCodeCache:NB_Code_File];
}
+(void)clearCodeCache:(NSString *)path{

    NSThread * newThread = [[NSThread alloc]initWithBlock:^{
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * pathLi = [NBTool getSandBoxLibraryPath];
        //获取要放置文件的路径
        NSString * destPath = [pathLi stringByAppendingPathComponent:path];
        NSArray * array = [fileManager contentsOfDirectoryAtPath:destPath error:nil];
        [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
            NSLog(@"%@",obj);
            [fileManager removeItemAtPath:[destPath stringByAppendingPathComponent:obj] error:nil];
        }];
        [NBTool showMessage:@"清理完毕!"];
    }];
    
    [newThread start];
    
}

+(BOOL)isTimeOutWithTimeInerval:(NSTimeInterval)timeInterval atItemPath:(NSString *)path{
    
    NSDictionary *dict =[[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
    
    NSDate * creationDate = [dict objectForKey:NSFileCreationDate];
    
    NSDate * currentDate =[NSDate date];
    
    NSTimeInterval interval=[currentDate timeIntervalSinceDate:creationDate];
    
    if (interval>timeInterval) {
        return YES;
    }
    return NO;
    
}


+(instancetype)manager{
    
    static NBStoreManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NBStoreManager alloc] initInstance];
        }
    });
    return manager;
}

/**
 *  初始化一个父类对象
 *
 *  @return 一个本类对象
 */
-(instancetype)initInstance{
    
    self = [super init];
    if (self) {
    }
    return self;
}


/**
 *  对于init方法进行处理抛出异常
 *
 */
- (instancetype)init
{
    @throw @"初始化对象失败,请采用类方法manager初始化单例对象.";
    
    return nil;
}
@end
