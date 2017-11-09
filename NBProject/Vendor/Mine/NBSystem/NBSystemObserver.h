//
//  NBSystemObserver.h
//  NBProject
//
//  Created by JayZhang on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSystemObserver : NSObject

@property(nonatomic,assign)BOOL isConnectted;//是否连接网络
@property(nonatomic,assign)BOOL showNetInfo;//是否提示网络信息 默认为提醒

+(instancetype)defaultObserver;


@end
