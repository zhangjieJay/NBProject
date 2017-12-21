//
//  NBNetWork.h
//  NBProject
//
//  Created by JayZhang on 17/8/25.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNetWork : NSObject
+(NSURLSessionDataTask *)postToUrl:(NSString *)sUrl param:(NSDictionary *)dicParam success:(successBlock)success failure:(failureBlock)failure;

+(NSURLSessionDataTask *)AFPostToUrl:(NSString *)sUrl param:(NSDictionary *)dicParam success:(successBlock)success failure:(failureBlock)failure;

@end
