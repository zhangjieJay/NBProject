//
//  BaseButton.m
//  wenzhong
//
//  Created by JayZhang on 17/3/23.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)load{
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [super allocWithZone:zone];
}

#pragma mark ------------------------------------ imageView frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect rect = contentRect;
    CGFloat ratio = 0.6;
    rect.size.width = contentRect.size.width * ratio;
    rect.size.height = rect.size.width;
    rect.origin.x = (1-ratio)/2.f * contentRect.size.width;
    return rect;
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = contentRect;
    CGFloat ratio = 0.4;
    rect.size.width = contentRect.size.width;
    rect.size.height = contentRect.size.height * ratio;
    rect.origin.y = (1-ratio) * contentRect.size.height;
    return rect;
}





@end
