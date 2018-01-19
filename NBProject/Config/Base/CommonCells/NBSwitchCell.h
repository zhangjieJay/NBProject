//
//  NBSwitchCell.h
//  NBProject
//
//  Created by 张杰 on 2018/1/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBSwitchDelegate <NSObject>
@optional
-(void)clickSwitch:(UISwitch *)sender isOn:(BOOL)isOn;
@end

@interface NBSwitchCell : UITableViewCell

/*数据模型类*/
@property(nonatomic,weak)id<NBSwitchDelegate>nbsw_delegate;
@property(nonatomic,strong)ParamModel * model;
@property(nonatomic,assign)BOOL isAPNS;//是否是关闭通知的

@end
