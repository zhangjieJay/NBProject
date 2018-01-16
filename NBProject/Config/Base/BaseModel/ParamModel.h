//
//  ParamModel.h
//  NBProject
//
//  Created by 张杰 on 2018/1/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseModel.h"

@interface ParamModel : BaseModel
/*标题*/
PROPERTY_NSSTRING(title);
/*副标题*/
PROPERTY_NSSTRING(sub_title);
/*参数值*/
PROPERTY_NSSTRING(value);
/*参数值对应的键值*/
PROPERTY_NSSTRING(key);
@end
