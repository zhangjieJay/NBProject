//
//  UserEntity.h
//  NBProject
//
//  Created by 张杰 on 2018/1/5.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseModel.h"

@interface UserEntity : BaseModel
PROPERTY_NSSTRING(name);
PROPERTY_NSSTRING(userID);
PROPERTY_NSSTRING(password);
PROPERTY_NSSTRING(token);
@end
