//
//  NBCodeButton.h
//  NBProject
//
//  Created by 张杰 on 2018/1/15.
//  Copyright © 2018年 Jay. All rights reserved.
//


/**
 ** 用于验证码发送按钮
 **/
#import "BaseButton.h"

@interface NBCodeButton : UIButton

@property(nonatomic,assign)NSInteger totalInteral;//总共时间

-(void)startWithInterral:(NSTimeInterval)interal;

//直接成button
-(instancetype)initToGetCustomButton;



@end
