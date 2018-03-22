//
//  NBHudView.m
//  NBProject
//
//  Created by 张杰 on 2018/1/30.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBHudView.h"
#import <ARKit/ARKit.h>

@interface NBHudView()


@end
@implementation NBHudView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(NBHudView *)showHudForView:(UIView *)view{
    
    NBHudView * hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    return hud;
}

-(instancetype)initWithView:(UIView *)view{
    
    return [self initWithFrame:view.bounds];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



@end
