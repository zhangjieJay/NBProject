//
//  NBCodeButton.m
//  NBProject
//
//  Created by 张杰 on 2018/1/15.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBCodeButton.h"

@interface NBCodeButton()
@property(nonatomic,strong)NSTimer * timer;
@end
@implementation NBCodeButton{
    NSInteger originTotal;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(startCountDown) userInfo:nil repeats:YES];
        _timer.fireDate = [NSDate distantFuture];
    }
    return _timer;
}


-(instancetype)initToGetCustomButton{
    
    self = [NBCodeButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectMake(100, 100, 120, 30);
    [self setBackgroundColor: [UIColor getColorNumber:30]];
    [self setTitleColor:[UIColor getColorNumber:0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor getColorNumber:600] forState:UIControlStateDisabled];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentNone;
    self.totalInteral = 5;
//    self.titleLabel.font = [NBTool getFont:12.f];
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return self;
}

#pragma mark ------------------------------------ 默认按钮点击事件
-(void)buttonClicked:(NBCodeButton *)sender{
    NSLog(@"点击了发送验证码按钮");
    
}

#pragma mark ------------------------------------ 点击时触发定时器
-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [super sendAction:action to:target forEvent:event];
    originTotal = self.totalInteral;
    self.enabled  = NO;
    [self startAnimation];
    self.timer.fireDate = [NSDate distantPast];//开启定时器
}

-(void)startAnimation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(2);
    animation.toValue = @(0.5);

    
    CABasicAnimation * animationO = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationO.fromValue = @(1);
    animationO.toValue = @(0.1);

    
    CAAnimationGroup * grounp = [CAAnimationGroup animation];
    grounp.animations = @[animation,animationO];
    grounp.duration = 1;
    grounp.repeatCount = MAXFLOAT;
    
    
//    self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.titleLabel.layer addAnimation:grounp forKey:@"scale"];
    
}

#pragma mark ------------------------------------ 开始计时
-(void)startCount{
    [self startWithInterral:self.totalInteral];
}
#pragma mark ------------------------------------ 定时器调用方法
-(void)startCountDown{
    if (originTotal>=1) {
        originTotal--;
        NSLog(@"剩余秒数:%lds",originTotal);
    }
    [self updateTitle];
}


#pragma mark ------------------------------------ 倒计时完毕处理
-(void)enableSelf{
    self.enabled = YES;
    [self setTitle:@"重发验证码" forState:UIControlStateNormal];
}

#pragma mark ------------------------------------ 初始化后立即调用
-(void)startWithInterral:(NSTimeInterval)interal{
    self.totalInteral = interal;
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(void)updateTitle{
    if (originTotal) {
        NSString * title = [NSString stringWithFormat:@"%lds",originTotal];
        [self setTitle:title forState:UIControlStateDisabled];
    }else{
        [self.titleLabel.layer removeAllAnimations];
        [self enableSelf];
        self.timer.fireDate = [NSDate distantFuture];
    }
}

-(void)valiuTimer{
    
    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
        NSLog(@"%@定时器被销毁了",NSStringFromClass([self class]));
    }
}


-(void)didMoveToSuperview{
    if (self.superview == nil) {
        [self valiuTimer];
    }
}


@end
