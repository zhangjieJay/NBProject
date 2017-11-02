//
//  BaseModel.m
//  wenzhong
//
//  Created by 张杰 on 2017/3/17.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


- (id)copyWithZone:(NSZone *)zone {

    BaseModel * model = [[BaseModel alloc] init];

    return model;

}
@end
