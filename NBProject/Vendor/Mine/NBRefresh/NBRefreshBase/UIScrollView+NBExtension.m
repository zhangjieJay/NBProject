//
//  UIScrollView+NBExtension.m
//  NBProject
//
//  Created by JayZhang on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIScrollView+NBExtension.h"
#import <objc/runtime.h>


@implementation UIScrollView (NBExtension)

- (UIEdgeInsets)nb_inset
{
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setNb_insetT:(CGFloat)nb_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = nb_insetT;
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)nb_insetT
{
    return self.nb_inset.top;
}

- (void)setNb_insetB:(CGFloat)nb_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = nb_insetB;
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)nb_insetB
{
    return self.nb_inset.bottom;
}

- (void)setNb_insetL:(CGFloat)nb_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = nb_insetL;
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)nb_insetL
{
    return self.contentInset.left;
}

- (void)setNb_insetR:(CGFloat)nb_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = nb_insetR;
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)nb_insetR
{
    return self.contentInset.right;
}

- (void)setNb_offsetX:(CGFloat)nb_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = nb_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)nb_offsetX
{
    return self.contentOffset.x;
}

- (void)setNb_offsetY:(CGFloat)nb_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = nb_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)nb_offsetY
{
    return self.contentOffset.y;
}

- (void)setNb_contentW:(CGFloat)nb_contentW
{
    CGSize size = self.contentSize;
    size.width = nb_contentW;
    self.contentSize = size;
}

- (CGFloat)nb_contentW
{
    return self.contentSize.width;
}

- (void)setNb_contentH:(CGFloat)nb_contentH
{
    CGSize size = self.contentSize;
    size.height = nb_contentH;
    self.contentSize = size;
}

- (CGFloat)nb_contentH
{
    return self.contentSize.height;
}
@end
