//
//  NSDictionary+NBSerializing.m
//  NBProject
//
//  Created by JayZhang on 17/8/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NSDictionary+NBSerializing.h"

@implementation NSDictionary (NBSerializing)

//把NSDictionary解析成post格式的NSString字符串
-(NSString *)convertToPostFormat{
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
//    NSMutableArray *array = [NSMutableArray new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [self keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [self valueForKey:key]];
        [result appendString:keyValueFormat];
//        [array addObject:keyValueFormat];
    }
    return result;
}

@end
