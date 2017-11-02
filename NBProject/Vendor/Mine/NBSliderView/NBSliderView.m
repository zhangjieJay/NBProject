//
//  NBSliderView.m
//  OptionView
//
//  Created by 张杰 on 2017/5/16.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "NBSliderView.h"

#define SLIDER_BTN_TAG 600

@interface NBSliderView()

@property(nonatomic,strong)NSMutableArray * arButton;

@property(nonatomic,strong)UIButton * btnCurrent;//当前选中的按钮



@property(nonatomic,strong)UIView * viewSlider;//滑动的挑

@property(nonatomic,strong)UIView * viewSep;//底部分割线

@property(nonatomic,strong)UIScrollView * contentScrollView;//滚动视图

@property(nonatomic,assign)NSInteger countPerPage;//最大个数 只有均分是此参数拥有
@property(nonatomic,assign)NSInteger totalCount;//总数



@property(nonatomic,assign)CGFloat scrollWidth;//scrollView的宽度


@end

@implementation NBSliderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.viewSep.backgroundColor = [UIColor getColorNumber:615];
    }
    return self;
}


- (UIView *)viewSep{
    
    if (!_viewSep) {
        _viewSep = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
        
        [self addSubview:_viewSep];
    }
    return _viewSep;
    
}
-(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.scrollWidth, self.bounds.size.height)];
        _contentScrollView.backgroundColor = self.backgroundColor;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
    
}
- (NSMutableArray *)arButton{
    if (!_arButton) {
        _arButton = [NSMutableArray array];
    }
    return _arButton;
}


-(UIView *)viewSlider{
    
    if (!_viewSlider) {
        _viewSlider = [[UIView alloc]init];
        _viewSlider.backgroundColor = self.barColor;
        _viewSlider.hidden = !self.showBar;
        [self.contentScrollView addSubview:_viewSlider];
    }
    return _viewSlider;
}

- (void)initData{
    _midGap = 10.f;
    _edgeGap = 10.f;
    _barHeight = 2.f;
    _countPerPage = 5;
    _btnWidthOffset = 20.f;
    _scrollWidth = NB_SCREEN_WIDTH;
    
    _showBar = YES;
    _showLine = YES;
    _isAverage = YES;
    _isAutoScroll = YES;
    
    _titleFont = [NBTool getFont:15.f];
    _barColor = [UIColor getColorNumber:130];
    _titleSeleColor = [UIColor getColorNumber:130];
    _titleDeseleColor = [UIColor getColorNumber:615];
    
}

-(void)setMidGap:(CGFloat)midGap{
    _midGap = midGap;
    if ([self haveData]) [self initUserInterface];
}
-(void)setEdgeGap:(CGFloat)edgeGap{
    _edgeGap = edgeGap;
    if ([self haveData]) [self initUserInterface];
}
-(void)setBarHeight:(CGFloat)barHeight{
    _barHeight = barHeight;
    CGRect rect = self.viewSlider.frame;
    rect.size.height = _barHeight;
    self.viewSlider.frame = rect;
}
-(void)setBtnWidthOffset:(CGFloat)btnWidthOffset{
    _btnWidthOffset = btnWidthOffset;
    if ([self haveData]) [self initUserInterface];
}



-(void)setShowBar:(BOOL)showBar{
    _showBar = showBar;
    self.viewSlider.hidden = !_showBar;
}
-(void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    self.viewSep.hidden = !_showLine;
}
-(void)setIsAverage:(BOOL)isAverage{
    if (_isAverage != isAverage) {
        _isAverage = isAverage;
        if ([self haveData]) [self initUserInterface];
    }
}
-(void)setIsAutoScroll:(BOOL)isAutoScroll{

    _isAutoScroll = isAutoScroll;
}


-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    if ([self haveData]) [self changeTitleFont];
}
-(void)setBarColor:(UIColor *)barColor{
    _barColor = barColor;
    self.viewSlider.backgroundColor = _barColor;
}
-(void)setTitleSeleColor:(UIColor *)titleSeleColor{
    _titleSeleColor = titleSeleColor;
    if ([self haveData]) [self changeUnableColor];
}
-(void)setTitleDeseleColor:(UIColor *)titleDeseleColor{
    _titleDeseleColor = titleDeseleColor;
    if ([self haveData]) [self changeNormalColor];
}






-(BOOL)haveData{
    return self.arTitle.count;
}

- (void)setArTitle:(NSArray *)arTitle{
    _arTitle = arTitle;
    [self initUserInterface];//初始化视图
}



-(void)changeUnableColor{
    for (int i = 0 ; i < self.totalCount; i++) {
        UIButton * tempBtn  = [self.arButton objectAtIndex:i];
        [tempBtn setTitleColor:self.titleSeleColor forState:UIControlStateDisabled];
    }
}
-(void)changeNormalColor{
    for (int i = 0 ; i < self.totalCount; i++) {
        UIButton * tempBtn  = [self.arButton objectAtIndex:i];
        [tempBtn setTitleColor:self.titleDeseleColor forState:UIControlStateNormal];
    }
}
-(void)changeTitleFont{
    for (int i = 0 ; i < self.totalCount; i++) {
        UIButton * tempBtn  = [self.arButton objectAtIndex:i];
        tempBtn.titleLabel.font = self.titleFont;
    }
}

#pragma mark ------------------------------------ 初始化界面
- (void)initUserInterface{
    
    self.totalCount = _arTitle.count;
    CGFloat buttonWidth = 0.0;
    if (self.isAverage) {//如果平均则不需要通过title进行计算
        if (self.totalCount>self.countPerPage) {
            buttonWidth = (self.scrollWidth - self.edgeGap * 2.f - (self.countPerPage - 1) * self.midGap)/self.countPerPage;//超过限制的最大个数则按照最大个数处理
        }else{
            buttonWidth = (self.scrollWidth - self.edgeGap * 2.f - (self.totalCount - 1) * self.midGap)/self.totalCount;//不论按钮多少全部存放在当前宽度中
        }
    }
    
    CGFloat ori_x =self.edgeGap;//每个按钮的起点
    
    
    CGFloat buttonHeight = self.bounds.size.height * 0.7;
    CGFloat y = self.bounds.size.height * 0.15;
    
    for (int i = 0 ; i < self.totalCount; i++) {
        
        UIButton * tempBtn  = [self.contentScrollView viewWithTag:i+SLIDER_BTN_TAG];
        if (!tempBtn) {
            tempBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
            tempBtn.titleLabel.font = self.titleFont;
            [tempBtn setTitleColor:self.titleDeseleColor forState:UIControlStateNormal];
            [tempBtn setTitleColor:self.titleSeleColor forState:UIControlStateDisabled];
            [tempBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tempBtn.tag = i+SLIDER_BTN_TAG;
            [self.arButton addObject:tempBtn];
            [self.contentScrollView addSubview:tempBtn];
        }
        /****当需要采用不平均按钮时****/
        if (!self.isAverage) {
            buttonWidth = [NBTool autoString:self.arTitle[i] font:self.titleFont width:self.scrollWidth].width  + self.btnWidthOffset;
        }
        
        tempBtn.frame = CGRectMake(ori_x,y,buttonWidth, buttonHeight);
        
        ori_x +=(buttonWidth + self.midGap);
        if (i == 0) {
            tempBtn.enabled = NO;
            self.btnCurrent = tempBtn;
            CGRect rect = tempBtn.frame;
            CGRect rectLine = [self getLineRectWithRect:rect index:i];
            self.viewSlider.frame = rectLine;
        }
        
        [tempBtn setTitle:self.arTitle[i] forState:UIControlStateNormal];
        [tempBtn setTitle:self.arTitle[i] forState:UIControlStateDisabled];
        
    }
    
    self.contentScrollView.contentSize =CGSizeMake(ori_x, self.bounds.size.height);
    
    
}



#pragma mark ------------------------------------ 按钮点击事件
-(void)buttonClicked:(UIButton *)sender{
    [self sliderToButton:sender];
    if (self.nbsv_delegate && [self.nbsv_delegate respondsToSelector:@selector(sliderView:didClickedButton:atIndex:)]) {
        [self.nbsv_delegate sliderView:self didClickedButton:sender atIndex:(sender.tag - SLIDER_BTN_TAG)];
    }
}
#pragma mark ------------------------------------ 只读属性的修改
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
}


- (void)scrollToindex:(NSInteger)index{
    
    if (index<self.arButton.count) {
        self.currentIndex = index;
        UIButton * button = [self. arButton objectAtIndex:index];
        [self sliderToButton:button];;
    }
}


- (void)sliderToButton:(UIButton *)sender{
    
    CGFloat originX = (sender.frame.origin.x + sender.frame.size.width/2.0);
    /**控制滚动视图偏移量的方法**/
    if (self.scrollWidth>=self.contentScrollView.contentSize.width) {
        //不需要进行滚动
    }else{
        if (originX < (self.scrollWidth/2.0)) {
            originX = 0;
        }
        else if ((originX + (self.scrollWidth/2.0)) > self.contentScrollView.contentSize.width){
            originX =self.contentScrollView.contentSize.width - self.scrollWidth;
        }
        else{
            originX = originX - self.scrollWidth/2.0;
        }
    }
    /********************/
    
    sender.enabled = NO;
    self.btnCurrent.enabled = YES;
    self.btnCurrent = sender;
    CGRect rect = sender.frame;
    NSInteger i = sender.tag - SLIDER_BTN_TAG;
    self.currentIndex = i;
    CGRect rectNew = [self getLineRectWithRect:rect index:i];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (self.showBar) {
            self.viewSlider.frame = rectNew;
        }
        
        if (self.isAutoScroll) {
            if (self.scrollWidth< self.contentScrollView.contentSize.width) {
                self.contentScrollView.contentOffset =CGPointMake(originX, 0);
            }
        }

    } completion:nil];
}

-(CGRect)getLineRectWithRect:(CGRect)rect index:(NSInteger)index{
    
    CGRect rectNow = rect;
    NSString  * title = [self.arTitle objectAtIndex:index];
    
    CGSize size = [NBTool autoString:title font:self.titleFont width:self.scrollWidth-self.edgeGap * 2.f];
    
    CGFloat widthMax = size.width + 10.f;
    
    if (rect.size.width <= widthMax) {
        
        
    }else{
        
        rectNow.origin.x+=( rect.size.width - widthMax)/2.f;
        rectNow.size.width = widthMax;
    }
    rectNow.origin.y = self.bounds.size.height - self.barHeight;
    rectNow.size.height = self.barHeight;
    
    return rectNow;
}

@end
