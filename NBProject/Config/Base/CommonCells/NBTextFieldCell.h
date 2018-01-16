//
//  NBTextFieldCell.h
//  NBProject
//
//  Created by 张杰 on 2018/1/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBTextFieldCell : UITableViewCell
/*数据模型类*/
@property(nonatomic,strong)ParamModel * model;
@property(nonatomic,strong)UITextField * tfInput;



@property(nonatomic,strong)NSIndexPath * path;
@property(nonatomic,weak)id target;
@end
