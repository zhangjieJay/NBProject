//
//  UIImageView+NB.m
//  NBProject
//
//  Created by 张杰 on 2018/5/29.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIImageView+NB.h"

@implementation UIImageView (NB)

-(void)addInvertedReflection{
    if (self.superview) {
        CGRect frame = self.frame;
        frame.origin.y += (frame.size.height + 1);
        UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
        self.clipsToBounds = YES;
        reflectionImageView.contentMode = self.contentMode;
        [reflectionImageView setImage:self.image];
        reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
        CALayer *reflectionLayer = [reflectionImageView layer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = reflectionLayer.bounds;
        gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
        gradientLayer.startPoint = CGPointMake(0.5,0.5);
        gradientLayer.endPoint = CGPointMake(0.5,1.0);
        reflectionLayer.mask = gradientLayer;
        [self.superview addSubview:reflectionImageView];
    }
}


#pragma mark ------------------------------------  画水印
- (void) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect{
    /*rect:水印位置*/
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        //原图
        [image drawInRect:self.bounds];
        //水印图
        [mark drawInRect:rect];
        UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.image = newPic;
    }

}


@end
