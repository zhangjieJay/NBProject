//
//  InputButton.m
//  NBProject
//
//  Created by 张杰 on 2018/7/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "InputButton.h"
#import "InputDataModel.h"
@implementation InputButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setModel:(InputDataModel *)model{
    
    _model = model;
    
    if (model.dataType == NBButtonTypeTitle_Only) {//普通字符串
        [self setTitle:model.displayName forState:UIControlStateNormal];
    }
    else if (model.dataType == NBButtonTypeTitle_None){//图片

        [self setImage:[UIImage imageNamed:model.value] forState:UIControlStateNormal];
        
    }
    
//    [self setTitle:model.displayName forState:UIControlStateNormal];

    
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
        
        [self addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents: UIControlEventTouchUpOutside];
        
        [self addTarget:self action:@selector(buttonTouhedCancelled:) forControlEvents:UIControlEventTouchCancel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouchedLongTime:)];
        
        longPress.minimumPressDuration = 0.8; //定义按的时间
        
        [self  addGestureRecognizer:longPress];
    }
    return self;
}
@end
