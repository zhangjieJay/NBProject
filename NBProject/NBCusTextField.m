//
//  NBMoneyTextField.m
//  NBProject
//
//  Created by 张杰 on 2018/7/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBCusTextField.h"
#import "InputButton.h"
@interface NBCusTextField()

@property(nonatomic,assign)NSInteger tagBase;//最新版本

@property(nonatomic,strong)BaseView * viewBack;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,weak)InputButton * longBtn;

@end

@implementation NBCusTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    NSLog(@"能够响应的方法%@", NSStringFromSelector(action));
    return NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInputView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInputView];
    }
    return self;
}


-(void)setupInputView{
    self.tagBase = 500;
    self.textColor = [UIColor whiteColor];
    NSArray * arData = @[@{@"displayName":@"1",@"value":@"1",@"dataType":@(1)},
                         @{@"displayName":@"2",@"value":@"2",@"dataType":@(1)},
                         @{@"displayName":@"3",@"value":@"3",@"dataType":@(1)},
                         @{@"displayName":@"4",@"value":@"4",@"dataType":@(1)},
                         @{@"displayName":@"5",@"value":@"5",@"dataType":@(1)},
                         @{@"displayName":@"6",@"value":@"6",@"dataType":@(1)},
                         @{@"displayName":@"7",@"value":@"7",@"dataType":@(1)},
                         @{@"displayName":@"8",@"value":@"8",@"dataType":@(1)},
                         @{@"displayName":@"9",@"value":@"9",@"dataType":@(1)},
                         @{@"displayName":@".",@"value":@".",@"dataType":@(1)},
                         @{@"displayName":@"0",@"value":@"0",@"dataType":@(1)},
                         @{@"displayName":@"<-",@"value":@"backSpace",@"dataType":@(6)}];

    
    

    NSInteger minCount = arData.count;
    
    CGFloat marginX = 0;  //按钮距离左边和右边的距离
    NSInteger numPerLine = 3;//一行多少个
    NSInteger orderRow;//当前是某行第几个
    NSInteger orderLine;//当前属于第几列
    UIButton * btnLast;//上一个
    CGFloat height = 45;
    NSInteger row = (minCount + numPerLine - 1)/numPerLine;//需要布置几行
    
    for (NSInteger i = 0 ; i<minCount; i++) {
        
        InputButton * btn = [self.viewBack viewWithTag:self.tagBase + i];
        orderRow = i % numPerLine;
        orderLine = i/numPerLine;
        if (!btn) {
            btn = [InputButton buttonWithType:UIButtonTypeCustom];
            btn.tag = self.tagBase + i;
            [self.viewBack addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                /*水平布局*/
                make.top.mas_equalTo(height * orderLine);
                make.width.mas_equalTo(self.viewBack.mas_width).multipliedBy(1.0/numPerLine);
                make.height.mas_equalTo(height);
                if (!btnLast || orderRow == 0) {  //btnLast为nil  或者orderRow == 0 说明换行了 每行的第一个确定它距离左边边缘的距离
                    make.left.mas_equalTo(marginX);
                }else{
                    make.left.mas_equalTo(btnLast.mas_right);
                }
            }];
//            if (((i+numPerLine)/numPerLine)<row) {//只要不在最后一行 则画横线
                //需要画底部线条
                UIView * viewHor = [UIView new];
                viewHor.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                [btn addSubview:viewHor];
                [viewHor mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                }];
                
//            }
            if (orderRow != (numPerLine -1)) {//只要不是最后一个则画竖向
                UIView * viewVer = [UIView new];
                viewVer.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                [btn addSubview:viewVer];
                [viewVer mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(0.5);
                }];
            }
        }
        NSDictionary * dic = [arData objectAtIndex:i];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouchedLongTime:)];
        
        longPress.minimumPressDuration = 0.8; //定义按的时间
        
        [btn addGestureRecognizer:longPress];
        
        InputDataModel * model = [InputDataModel new];
        [model setValuesForKeysWithDictionary:dic];
        btn.model = model;
        [btn setTitleColor:[UIColor colorWithHexString:@"#134A9F"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btnLast = btn;
    }
//    /*最后一个需要对viewbtns的高度进行动态计算*/
//    [btnLast mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.viewBack.mas_bottom);
//    }];
    
}
-(BaseView *)viewBack{
    
    
    if (!_viewBack) {
        _viewBack = [BaseView new];
        _viewBack.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        _viewBack.frame = CGRectMake(0, 0, NB_SCREEN_WIDTH, BIsiPhoneX?214:180);
        self.inputAccessoryView.backgroundColor = [UIColor colorWithHexString:@"#CD5C5C"];

        self.inputView = _viewBack;
    }
    return _viewBack;
}
-(void)buttonClicked:(InputButton *)sender{
    
    InputDataModel * model = sender.model;
    
    if (self.text == nil && [model.value isEqualToString:@"."]) {
        return;
    }
    
    if ([self.text containsString:@"."] && [model.value isEqualToString:@"."]) {//已经输入过小数点了
        return;
    }
    if (model.dataType == NBButtonTypeTitle_Only) {//普通字符串
        [self insertText:sender.model.value];
    }
    else if (model.dataType == NBButtonTypeTitle_None){//图片
            [self deleteBackward];
    }
}

#pragma mark ------------------------------------ 长按事件处理
-(void)buttonTouchedLongTime:(UILongPressGestureRecognizer *)longGR {
    if (longGR.state == UIGestureRecognizerStateBegan) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(repeatAction:) userInfo:nil repeats:YES];
        if ([longGR.view isKindOfClass:[InputButton class]]) {
            self.longBtn = (InputButton *)longGR.view;
        }
    }else if (longGR.state == UIGestureRecognizerStateEnded || longGR.state == UIGestureRecognizerStateCancelled){
        [_timer invalidate];
        _timer = nil;
        self.longBtn = nil;
    }
    
}
-(void)repeatAction:(UIView *)view{
    if (self.longBtn) {
        [self buttonClicked:self.longBtn];
    }
}


@end
