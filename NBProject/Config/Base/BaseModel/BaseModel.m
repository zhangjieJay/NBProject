//
//  BaseModel.m
//  wenzhong
//
//  Created by 张杰 on 2017/3/17.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}
/**
 *  根据类动画获取类的所有属性,不要忘记导入#import <objc/runtime.h>
 *
 *  @param cls 类名
 *
 *  @return  类属性数组
 */
- (NSArray *)perperiesWithClass:(Class)cls
{
    NSMutableArray *perperies = [NSMutableArray array];
    unsigned int outCount;
    //动态获取属性
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    //遍历person类的所有属性
    for (int i = 0; i < outCount; i++){
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString * sProName = [[NSString alloc] initWithUTF8String:name];
        [perperies addObject:sProName];
    }
    return perperies;
}


- (id)copyWithZone:(NSZone *)zone {
    BaseModel * model = [[BaseModel alloc] init];
    return model;
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    BaseModel * model = [[BaseModel alloc] init];
    return model;
}

#pragma mark ------------------------------------ 归档
/**
 *  归档会触发
 *
 *  @param aCoder 归档
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    for (NSString *perperty in [self perperiesWithClass:[self class]]){
        id obj = [self valueForKey:perperty];
        [aCoder encodeObject:obj forKey:perperty];
    }
}

#pragma mark ------------------------------------ 解档
/**
 *  解归档会触发
 *
 *  @param aDecoder 解档
 *
 *  @return model
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        for (NSString *perperty in [self perperiesWithClass:[self class]]){
            id value = [aDecoder decodeObjectForKey:perperty];
            [self setValue:value forKey:perperty];;
        }
    }
    return self;
}
@end
