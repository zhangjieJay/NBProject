//
//  NSString+NB.m
//  NBProject
//
//  Created by 张杰 on 2018/5/29.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NSString+NB.h"

@implementation NSString (NB)
- (NSString *)removeSpaceAndNewliner{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
@end
