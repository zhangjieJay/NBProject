//
//  NBVolumeBar.m
//  NBProject
//
//  Created by 峥刘 on 17/8/22.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBVolumeBar.h"

@interface NBVolumeBar()

@property(nonatomic,strong)UIView * bar;

@end

@implementation NBVolumeBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.windowLevel = UIWindowLevelAlert -2;
        self.backgroundColor = [NBTool getColorNumber:0];
        [self makeKeyAndVisible];
    }
    return self;
}


-(instancetype)init{

    return [self initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, 20.f)];

}
-(UIView *)bar{

    if (!_bar) {
        CGFloat h = 3.f;
        _bar = [[UIView alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)- h)/2.f, NB_SCREEN_WIDTH, h)];
        _bar.backgroundColor = [NBTool getColorNumber:705];
        [self addSubview:_bar];
    }
    return _bar;
}

-(void)refreshVolumeBarWithValue:(CGFloat)value{

    CGRect frame = self.bar.frame;
    frame.size.width = NB_SCREEN_WIDTH * value;
    self.bar.frame = frame;
    
}

@end
