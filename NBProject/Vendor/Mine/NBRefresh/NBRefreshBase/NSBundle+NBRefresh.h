//
//  NSBundle+NBRefresh.h
//  NBProject
//
//  Created by JayZhang on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSBundle (NBRefresh)
+ (instancetype)nb_refreshBundle;
+ (UIImage *)nb_arrowImage;
+ (NSString *)nb_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)nb_localizedStringForKey:(NSString *)key;
@end
