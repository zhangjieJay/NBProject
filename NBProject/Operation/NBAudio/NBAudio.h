//
//  NBAudioTool.h
//  NBProject
//
//  Created by 张杰 on 2017/12/20.
//  Copyright © 2017年 Jay. All rights reserved.
//
/*
 **将文字转化为语音的类,并且播放出来**
 */
#import <Foundation/Foundation.h>

@interface NBAudio : NSObject

+(instancetype)shareInstance;
//根据文字播放语音
-(void)playVoiceString:(NSString *)sString;


@end
