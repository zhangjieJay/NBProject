//
//  NBIPTool.h
//  NBProject
//
//  Created by JayZhang on 17/8/21.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBIPTool : NSObject

+ (NSDictionary *)getIPAddresses;
+ (NSString *)getIPAddressIsIPV4:(BOOL)preferIPv4;

@end
