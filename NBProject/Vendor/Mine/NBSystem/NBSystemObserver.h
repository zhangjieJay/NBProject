//
//  NBSystemObserver.h
//  NBProject
//
//  Created by 峥刘 on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSystemObserver : NSObject

@property(nonatomic,assign)BOOL isConnectted;

+(instancetype)defaultObserver;


@end
