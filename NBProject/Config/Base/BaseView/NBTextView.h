//
//  NBTextView.h
//  LivingMuseumMF
//
//  Created by Jay on 17/4/25.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NBTextView;

@protocol NBTextViewDelegate <NSObject>

@optional

-(void)NBTextView:(NBTextView *)text textValueChange:(NSString *)sText;

@end



@interface NBTextView : UITextView

@property(nonatomic,copy) NSString *myPlaceholder;  //文字
@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色
@property(nonatomic,assign)NSInteger maxCharacters;//最大输入数目,默认200

@property(nonatomic,weak)id<NBTextViewDelegate>NBTextViewDelegate;
@property(nonatomic,weak)id target;//主要用户判断是否相应target所实现的方法

@end
