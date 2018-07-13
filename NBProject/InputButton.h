//
//  InputButton.h
//  NBProject
//
//  Created by 张杰 on 2018/7/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputDataModel.h"
@protocol CustomButtonDelegate<NSObject>
@optional

-(void)buttonTouchedDown:(UIButton*)button;

-(void)buttonTouchedUpOutside:(UIButton*)button;

-(void)buttonTouhedCancelled:(UIButton*)button;

-(void)buttonTouchedLongTime:(UIButton*)button;


@end

@interface InputButton : UIButton
@property(nonatomic,strong)InputDataModel * model;
@end
