//
//  SheetModel.h
//  NBProject
//
//  Created by 峥刘 on 17/8/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "BaseModel.h"

@interface SheetModel : BaseModel
PROPERTY_NSSTRING(key);//区分该值所对应的key,以便灵活控制点击事项
PROPERTY_NSSTRING(value);//值(主要用于和后台交互)
PROPERTY_NSSTRING(displayValue);//显示名称(主要用户界面显示)
@end
