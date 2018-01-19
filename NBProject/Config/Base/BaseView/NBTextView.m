//
//  NBTextView.m
//  LivingMuseumMF
//
//  Created by Jay on 17/4/25.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBTextView.h"

@interface NBTextView()<UITextViewDelegate>

@property (nonatomic,weak) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用

@end

@implementation NBTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc{
    NSLog(@"NBTextView 被释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
}
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate =self;
        self.backgroundColor= [UIColor clearColor];
        self.myPlaceholder = @"请输入文字";
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        _maxCharacters = 200;
        placeholderLabel.backgroundColor= [UIColor clearColor];
        placeholderLabel.font = [NBTool getFont:15.f];
        placeholderLabel.numberOfLines = 0; //设置可以输入多行文字时可以自动换行
        [self addSubview:placeholderLabel];
        
        self.placeholderLabel= placeholderLabel; //赋值保存
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
        self.font= [NBTool getFont:15.f]; //设置默认的字体
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil]; //通知:监听文字的改变
    }
    return self;
}

-(void)setMaxCharacters:(NSInteger)maxCharacters{

    _maxCharacters = maxCharacters;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //超过上限的时候控制数据
    if (range.length + range.location > textView.text.length) {
        return NO;
    }
    NSInteger length = textView.text.length + text.length - range.length;
//    return length <= self.maxCharacters;
    
    if (length <= self.maxCharacters) {
        return YES;
    }else{
        NSLog(@"%@",[NSString stringWithFormat:@"最多允许输入%ld个字符",self.maxCharacters]);
        return NO;
    }
}


- (void)textDidChange {
    
    if (self.hasText) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
    
    if (self.NBTextViewDelegate && [self.NBTextViewDelegate respondsToSelector:@selector(NBTextView:textValueChange:)]) {
        [self.NBTextViewDelegate NBTextView:self textValueChange:self.text];
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.placeholderLabel.textColor = self.myPlaceholderColor;
    
    if (self.hasText) {
        self.placeholderLabel.hidden = YES;
        self.placeholderLabel.text = self.myPlaceholder;

    }else{
        self.placeholderLabel.hidden = NO;
        self.placeholderLabel.text = self.myPlaceholder;
        CGRect frame = CGRectZero;
        frame.origin.y= sHeight(6); //设置UILabel 的 y值
        frame.origin.x= sWidth(10);//设置 UILabel 的 x 值
        frame.size.width= self.frame.size.width-frame.origin.x*2.0; //设置 UILabel 的 x
        
        //根据文字计算高度
        
        CGSize maxSize =CGSizeMake(frame.size.width,self.frame.size.height -frame.origin.y * 2.0);
        frame.size.height= [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
        self.placeholderLabel.frame = frame;
    }
    

}



@end
