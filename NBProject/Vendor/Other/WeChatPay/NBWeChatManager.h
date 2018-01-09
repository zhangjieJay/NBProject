//
//  NBWeChatManager.h
//  NBProject
//
//  Created by Jay on 17/6/28.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayReq;



@interface NBWeChatManager : NSObject

@property(nonatomic,copy)NSString * productName;//商品名称
@property(nonatomic,copy)NSString * productPrice;//商品价格
@property(nonatomic,copy)NSString * orderNo;//订单号

/*单例*/
+(instancetype)sharedManager;


/*获取构造好的model,但是前提需要配置相关参数,变动参数为.h中的属性,其他均为固定参数.m宏定义进行修改*/

+(PayReq *)getPayReq;

+(void)clearParams;//清除参数



@end
