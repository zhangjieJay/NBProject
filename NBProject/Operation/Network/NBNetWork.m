//
//  NBNetWork.m
//  NBProject
//
//  Created by 峥刘 on 17/8/25.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBNetWork.h"

@interface NBNetWork()


@end

@implementation NBNetWork

+(NSURLSessionDataTask *)postToUrl:(NSString *)sUrl param:(NSDictionary *)dicParam success:(successBlock)success failure:(failureBlock)failure{

    /*判断网络连接是否可用*/
    if (![NBSystemObserver defaultObserver].isConnectted) {
        [NBTool showMessage:NB_Error_Disconnect];
        failure(NB_Error_Disconnect);
        return nil;
    }
    
    NSURL * url = [NSURL URLWithString:sUrl];

    //设置缓存策略及请求超时时间
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    [request setHTTPBody:[[dicParam convertToPostFormat] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置请求类型
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        /*主线程中进行数据分析和处理*/
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {//请求出错
                [NBTool showMessage:NB_Error_Request];
                failure(NB_Error_Request);
            }else{
                NSError * jsError = nil;
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsError];
                if (jsError) {//数据格式解析出错
                    [NBTool showMessage:NB_Error_Data];
                    failure(NB_Error_Data);
                }else{
                    success(dic);
                }
            }
        });
    }];

    [dataTask resume];//启动网络请求
    return dataTask;
}


//-(void)code:(NSString *)url{
//
//    NSURL *nsurl = [NSURL URLWithString:url];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
//    //如果想要设置网络超时的时间的话，可以使用下面的方法：
//    //NSMutableURLRequest *mutableRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    //设置请求类型
//    request.HTTPMethod = @"POST";
//    NSString *postStr = @"";
//    //把参数放到请求体内
//    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) { //请求失败
//            failureBlock(error);
//        } else {  //请求成功
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            successBlock(dic);
//        }
//    }];
//    [dataTask resume];  //开始请求
//
//
//}

@end
