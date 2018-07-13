//
//  InputDataModel.h
//  NBProject
//
//  Created by 张杰 on 2018/7/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseModel.h"

@interface InputDataModel : BaseModel
@property(nonatomic,copy)NSString * displayName;
@property(nonatomic,copy)NSString * displaySubname;

@property(nonatomic,copy)NSString * value;
@property(nonatomic,copy)NSString * key;

@property(nonatomic,assign)NBButtonType dataType;//输入数据烈性

@end
