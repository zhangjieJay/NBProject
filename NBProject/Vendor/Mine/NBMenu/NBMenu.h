//
//  NBMenu.h
//  NBProject
//
//  Created by 张杰 on 2018/5/24.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBMenuItem : NSObject
@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, strong) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;
+ (instancetype) menuItem:(NSString *) title image:(UIImage *) image target:(id)target action:(SEL) action;

@end

@interface NBMenu : NSObject
+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems;

+ (void) dismissMenu;

+ (UIColor *)tintColor;
+ (void)setTintColor: (UIColor *) tintColor;

+ (UIFont *)titleFont;
+ (void)setTitleFont: (UIFont *) titleFont;
@end


