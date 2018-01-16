//
//  NBCountingLabel.h
//  NBProject
//
//  Created by 张杰 on 2018/1/16.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSString* (^NBCountingLabelFormatBlock)(CGFloat value);
typedef NSAttributedString* (^NBCountingLabelAttributedFormatBlock)(CGFloat value);
@interface NBCountingLabel : UILabel

@property(nonatomic, copy)NSString *format; //数据格式 @"%d"   @"%.1f%%"
@property(nonatomic, copy)void (^completionBlock)(void);//完成后的回调
@property(nonatomic, copy)NBCountingLabelFormatBlock formatBlock;//自定义前缀或者后缀格式或其他格式
@property(nonatomic, copy)NBCountingLabelAttributedFormatBlock attributedFormatBlock;//自定义富文本格式



-(void)countFromZeroTo:(NSString *)toValue;
-(void)countFrom:(NSString *)fromValue to:(NSString *)toValue;
-(void)countFromZeroTo:(NSString *)toValue withDuration:(NSTimeInterval)duration;
-(void)countFrom:(NSString *)fromValue to:(NSString *)toValue duration:(NSTimeInterval)duration;

@end
