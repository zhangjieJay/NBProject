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

#pragma mark ------------------------------------ imageView frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return [self getRectIsTitle:NO rect:contentRect];
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return [self getRectIsTitle:YES rect:contentRect];
}


-(CGRect)getRectIsTitle:(BOOL)isTitle rect:(CGRect)contentRect{
    //    NBButtonTypeDefault,                /*标题和图片*/
    //    NBButtonTypeTitle_Only,             /*只有标题,无图片*/
    //    NBButtonTypeTitle_Up,               /*标题在上部,图片在下部*/
    //    NBButtonTypeTitle_Left,             /*标题在左部,图片在右部*/
    //    NBButtonTypeTitle_Bottom,           /*标题在下部,图片在上部*/
    //    NBButtonTypeTitle_Right,            /*标题在右部,图片在左部*/
    //    NBButtonTypeTitle_None,             /*无标题只有图片*/
    CGRect rect = contentRect;

    
    switch (self.nb_titleType) {
        case NBButtonTypeTitle_Right:
            if (!isTitle){//图片
                rect.size.width = contentRect.size.width * self.nb_scale;
                rect = [self convertRectToCenter:rect withSize:CGSizeMake(1, 1)];
            }else{//标题
                rect.origin.x = contentRect.size.width * self.nb_scale;
                rect.size.width = contentRect.size.width * (1- self.nb_scale);
            }
            break;
        case NBButtonTypeDefault:
        case NBButtonTypeTitle_Only:
            if (!isTitle){
                rect = CGRectZero;
            }
            break;
        case NBButtonTypeTitle_Up:
            if (isTitle){
                rect.size.height = contentRect.size.height * self.nb_scale;
            }else{
                rect.origin.y = contentRect.size.height * self.nb_scale;
                rect.size.height = contentRect.size.height * (1- self.nb_scale);
                rect = [self convertRectToCenter:rect withSize:CGSizeMake(1, 1)];
            }
            break;
        case NBButtonTypeTitle_Left:
            if (isTitle){//标题
                rect.size.width = contentRect.size.width * self.nb_scale;
            }else{//
                rect.origin.x = contentRect.size.width * self.nb_scale;
                rect.size.width = contentRect.size.width * (1- self.nb_scale);
                rect = [self convertRectToCenter:rect withSize:CGSizeMake(1, 1)];
            }
            break;
        case NBButtonTypeTitle_Bottom:
            if (!isTitle){
                rect.size.height = contentRect.size.height * self.nb_scale;
                rect = [self convertRectToCenter:rect withSize:CGSizeMake(1, 1)];
            }else{
                rect.origin.y = contentRect.size.height * self.nb_scale;
                rect.size.height = contentRect.size.height * (1- self.nb_scale);
            }
            break;
        case NBButtonTypeTitle_None: /*只有图片*/
            if (isTitle){
                rect = CGRectZero;
            }
            rect = [self convertRectToCenter:rect withSize:CGSizeMake(1, 1)];

            break;
        default:
            break;
    }
    return  rect;
}

-(CGRect)convertRectToCenter:(CGRect)rect withSize:(CGSize)size{
    
    CGFloat size_scalew_h = size.width/size.height;//>1宽图  否则为高图
    CGFloat rect_scalew_h = rect.size.width/rect.size.height;//>1宽图  否则为高图
    CGRect newRect = rect;
    if (size_scalew_h>=rect_scalew_h) {//按比例放置图片过宽装不下  所以横向装满 竖向填空
        newRect.size.height = rect_scalew_h/size_scalew_h * rect.size.height;
        newRect.origin.y = (rect.size.height - newRect.size.height)/2.f;
    }else{
        newRect.size.width = size_scalew_h/rect_scalew_h * rect.size.width;
        newRect.origin.x = (rect.size.width - newRect.size.width)/2.f;
        
    }
    return newRect;
}


@end
