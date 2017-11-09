//
//  NBRemindView.m
//  WenZhongOrder
//
//  Created by JayZhang on 17/6/1.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBAlertView.h"
#import "BaseButton.h"
#import "BaseView.h"

#define bTag 300


@interface NBAlertView()


@property(nonatomic,strong)BaseView * viewCenter;//中间底部视图

@property(nonatomic,strong)UIImageView * igvInfo;//提示视图

@property(nonatomic,strong)UILabel * lbTitle;//提示标题
@property(nonatomic,strong)UILabel * lbInfo;//提示视图
@property(nonatomic,assign)CGFloat max_Y;//最大May


@end


@implementation NBAlertView{
    
    CGFloat cen_w;
    CGFloat cen_h;
    CGFloat ig_scale;// cen_w 图片的比例
    CGFloat gap_scale; //top left down right 的缝隙宽度
    CGFloat info_height;//可变化文字动态自适应高度
    CGFloat title_font;//标题字体
    CGFloat info_font;//文字字体
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initBaseData];
    }
    return self;
}




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initBaseData];
    }
    return self;
}



-(void)initBaseData{
    
    cen_w = 0.8 * NB_SCREEN_WIDTH;
    cen_h = 0.6 * NB_SCREEN_WIDTH;//可能不需要
    ig_scale = 0.15f;
    gap_scale = 0.05f;
    title_font = 18.f ;
    info_font = 15.f;
    self.frame = CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT);
    self.backgroundColor = [[UIColor getColorNumber:1] colorWithAlphaComponent:0.6f];
}

- (UIImageView *)igvInfo{
    
    if (!_igvInfo) {
        _igvInfo = [[UIImageView alloc]initWithFrame:CGRectMake(cen_w * (1- ig_scale)/2.f, cen_w * gap_scale,cen_w * ig_scale , cen_w *ig_scale)];
        //        _igvInfo.image = [UIImage imageNamed:@"NB_completed_icon"];
        _igvInfo.image = [UIImage imageNamed:@"NB_skull_icon"];
        
        self.max_Y = CGRectGetMaxY(_igvInfo.frame);
    }
    return _igvInfo;
    
}

-(UILabel *)lbTitle{
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.igvInfo.frame)+cen_w * gap_scale, cen_w, (title_font + 5.f))];
        _lbTitle.font = [NBTool getFont:title_font bold:YES];
        _lbTitle.textColor = [UIColor getColorNumber:1];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.numberOfLines = 0;
        self.max_Y = CGRectGetMaxY(_lbTitle.frame);
        [self.viewCenter addSubview:_lbTitle];
        
        
    }
    return _lbTitle;
}

-(UILabel *)lbInfo{
    if (!_lbInfo) {
        _lbInfo = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbInfo.font = [NBTool getFont:cen_w * 0.1 * 0.5];
        _lbInfo.textColor = [UIColor getColorNumber:35];
        _lbInfo.numberOfLines = 0;
        _lbInfo.textAlignment = NSTextAlignmentCenter;
        [self.viewCenter addSubview:_lbInfo];
    }
    return _lbInfo;
}


- (BaseView *)viewCenter{
    
    if (!_viewCenter) {
        _viewCenter =[[BaseView alloc]init];
        _viewCenter.backgroundColor = [UIColor getColorNumber:5];
        [_viewCenter addSubview:self.igvInfo];
        [self addSubview:_viewCenter];
    }
    
    return _viewCenter;
}


- (void)show:(NSString *)info{
    self.igvInfo.image = [UIImage imageNamed:@"NB_skull_icon"];
    [self show:info title:@"温馨提示" options:@[@"确定"]];
}



- (void)showError:(NSString *)info{
    [self showError:info options:@[@"确定"]];
}

-(void)showError:(NSString *)info options:(NSArray <NSString *>*)options{
    self.igvInfo.image = [UIImage imageNamed:@"NB_crying_icon"];
    [self show:info title:@"出错啦~" options:options];
}

- (void)showSuccess:(NSString *)info{
    [self showSuccess:info options:@[@"确定"]];
}
-(void)showSuccess:(NSString *)info options:(NSArray <NSString *> *)options{
    self.igvInfo.image = [UIImage imageNamed:@"NB_completed_icon"];
    [self show:info title:@"温馨提示" options:options];
}

#pragma mark -------------------------------------------------------- 初始化控件及主要方法
- (void)show:(NSString *)sInfo title:(NSString *)title options:(NSArray <NSString *>*)options{
    
    if ([NBTool isEmpty:options]) {
        options =@[@"确定"];
    }
    
    self.lbTitle.text = title;
    
    //计算显示文字的高度
    CGSize size = [NBTool autoString:sInfo size:title_font width:cen_w * (1 - gap_scale * 2.f) height:NB_SCREEN_HEIGHT-200.f];
    CGFloat x = (cen_w - size.width)/2.f;
    self.lbInfo.frame = CGRectMake(x, self.max_Y + cen_w * gap_scale, size.width, size.height);
    self.lbInfo.text = sInfo;
    self.max_Y = CGRectGetMaxY(self.lbInfo.frame);
    
    
    NSInteger nCount = options.count;
    CGFloat gap = cen_w * gap_scale;
    
    
    CGFloat acWidth = (cen_w - gap * 2.f - gap * (nCount -1))/nCount;
    
    CGFloat height = 35.f;
    
    for (NSInteger i = 0; i<nCount; i++) {
        
        BaseButton * button  = [BaseButton buttonWithType:UIButtonTypeCustom];
        button.tag =  bTag + i;
        button.frame = CGRectMake(gap + (gap + acWidth) * i, self.max_Y + cen_w * gap_scale, acWidth, height);
        [button drawBezierCornerWithRatio:2.5f];
        if (nCount == 1) {
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor getColorNumber:100]] forState:UIControlStateNormal];

        }else{
            if (i==0) {
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor getColorNumber:25]] forState:UIControlStateNormal];

            }else{
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor getColorNumber:410]] forState:UIControlStateNormal];

            }
        }
        

        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonOtherClickedOut:) forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self action:@selector(buttonOtherClickedIn:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(buttonOtherClickedIn:) forControlEvents:UIControlEventTouchDragInside];

        [button addTarget:self action:@selector(buttonOtherClickedCancel:) forControlEvents:UIControlEventTouchUpOutside];

 
        [button setTitle:options[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor getColorNumber:0] forState:UIControlStateNormal];
        button.titleLabel.font = [NBTool getFont:height * 0.5 name:@"Optima"];
        [self.viewCenter addSubview:button];
        
        if(i == nCount-1){
            self.max_Y = CGRectGetMaxY(button.frame);
        }
    }
    
    self.viewCenter.frame = CGRectMake((NB_SCREEN_WIDTH -cen_w)/2.f, (NB_SCREEN_HEIGHT - self.max_Y - cen_w * gap_scale)/2.f, cen_w, self.max_Y + cen_w * gap_scale);
    [self.viewCenter drawBezierCornerWithRatio: NB_Gap_10];
    
    [NB_KEYWINDOW addSubview:self];
    [self.viewCenter animateWithDuration:0.25 fromScale:0.3 toScale:1];
    
    
}


- (void)buttonClicked:(BaseButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickAtIndex:)]) {
        [self.delegate alertView:self clickAtIndex:sender.tag - bTag];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0;
        self.viewCenter.layer.affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        self.viewCenter.alpha = 0.01;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/*在不可操作区域的时候*/
-(void)buttonOtherClickedOut:(BaseButton *)sender{
    NSLog_Method;
    sender.alpha = 0.382;
    
}

-(void)buttonOtherClickedIn:(BaseButton *)sender{
    NSLog_Method;
    sender.alpha = 1;
    
}


-(void)buttonOtherClickedCancel:(BaseButton *)sender{
    NSLog_Method;
    sender.alpha = 1;
}


@end
