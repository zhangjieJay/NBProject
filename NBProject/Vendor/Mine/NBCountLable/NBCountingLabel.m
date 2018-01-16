//
//  NBCountingLabel.m
//  NBProject
//
//  Created by 张杰 on 2018/1/16.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBCountingLabel.h"
#import <QuartzCore/QuartzCore.h>


@interface NBCountingLabel()
@property NSTimeInterval progress;  //当前已完成进度
@property NSTimeInterval totalTime; //总共时长
@property NSTimeInterval lastUpdate;//上次刷新
@property double fromValue;
@property double toValue;

@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation NBCountingLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)countFromZeroTo:(NSString *)toValue{
    [self countFrom:@"0" to:toValue];
}
- (void)countFromZeroTo:(NSString *)toValue withDuration:(NSTimeInterval)duration {
    [self countFrom:@"0" to:toValue duration:duration];
}
-(void)countFrom:(NSString *)fromValue to:(NSString *)toValue{
    [self countFrom:fromValue to:toValue duration:2.f];
}
-(void)countFrom:(NSString *)fromValue to:(NSString *)toValue duration:(NSTimeInterval)duration{
    
    self.fromValue = [NBTool decimalNumber:fromValue].doubleValue;
    self.toValue = [NBTool decimalNumber:toValue].doubleValue;
    // remove any (possible) old timers
    [self.timer invalidate];
    self.timer = nil;
    self.progress = 0;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];
    if (duration<=0) {
        duration = 2.f;
    }
    self.totalTime = duration;
    
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    timer.frameInterval = 6;//系统默认为1 即1s 60贞   改为6后 60/6 即每秒10贞
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    
}
#pragma mark ------------------------------------ 频率刷新timer
- (void)updateValue:(NSTimer *)timer {
    //update progress
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.lastUpdate;//现在刷新的时间减去上次刷新的时间差  即时间间隔
    self.lastUpdate = now;
    
    if (self.progress >= self.totalTime) {//当所有时间间隔相加 = duration 即动画结束
        [self.timer invalidate];
        self.timer = nil;
        self.progress = self.totalTime;
    }
    
    [self setTextValue:[self currentValue]];//更新text

    if (self.progress == self.totalTime) {//完成更新
        [self runCompletionBlock];
    }
}
- (void)setFormat:(NSString *)format {
    _format = [format copy];
    [self setTextValue:self.currentValue];
}
#pragma mark ------------------------------------ 完成后的回调
- (void)runCompletionBlock {
    [self.timer removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = nil;
    }
}

#pragma mark ------------------------------------ 改变text值
- (void)setTextValue:(double)value
{
    if (self.attributedFormatBlock != nil) {//富文本
        self.attributedText = self.attributedFormatBlock(value);
    }
    else if(self.formatBlock != nil){//拼接格式
        self.text = self.formatBlock(value);
    }
    else{//可设置的格式
        // check if counting with ints - cast to int
        if([self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound || [self.format rangeOfString:@"%(.*)i"].location != NSNotFound ){
            self.text = [NSString stringWithFormat:self.format,(int)value];
        }
        else{
            self.text = [NSString stringWithFormat:self.format,value];
        }
    }
}

#pragma mark ------------------------------------ 根据进度获取当前的数值
- (double)currentValue{
    if (self.progress >= self.totalTime) {//当前时间
        return self.toValue;
    }
    double percent = self.progress / self.totalTime;
    return self.fromValue + (percent * (self.toValue - self.fromValue));
}

@end
