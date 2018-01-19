//
//  BannerView.m
//  NBProject
//
//  Created by JayZhang on 17/3/23.
//  Copyright © 2017年 none. All rights reserved.
//

#import "NBBannerView.h"
#define ImageTag 20000
@interface NBBannerView ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray * arShow;

@property(nonatomic,strong)UIScrollView * baseScrollView;//底部滚动视图

@property(nonatomic,strong)UIPageControl * pageControl;//

@end


@implementation NBBannerView{
    
    NSInteger nCount;//实际个数
    NSInteger totalCount;//创建imageview个数
    
    NSTimer * timer;//定时器
    NSInteger currentPage;//当前的页数
    CGFloat width;
    CGFloat height;
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefultParams];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame ImageUrl:(NSArray <NSString *>*)arUrls
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arImages = arUrls;
        width = frame.size.width;
        height = frame.size.height;
        nCount = self.arImages.count;
        [self initDefultParams];
        [self createControls];
        [self dealData];//处理数据
        
    }
    return self;
}

-(UIScrollView *)baseScrollView{

    if (!_baseScrollView) {
        _baseScrollView  = [[UIScrollView alloc]initWithFrame:self.bounds];
        _baseScrollView.delegate = self;
        _baseScrollView.bounces = YES;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;//不显竖向滚动条
        [self addSubview:_baseScrollView];
        [self addSubview:self.pageControl];
    }
    return _baseScrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = NBAPPCOLOR;
        _pageControl.currentPageIndicatorTintColor =[UIColor getColorNumber:500];
    }
    return _pageControl;
}
-(void)initDefultParams{
    
    _stopInterval = 2.f;
    self.canAutoScroll = YES;
    self.canTunrPage = YES;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    width = frame.size.width;
    height = frame.size.height;
    [self createControls];
    [self dealData];
    
}


-(void)setArImages:(NSArray *)arImages{

    _arImages = arImages;
    nCount = _arImages.count;
    [self dealData];

}

-(void)setStopInterval:(CGFloat)stopInterval{
    
    _stopInterval = stopInterval;
}




-(void)createControls{
    
    self.baseScrollView.frame = self.bounds;
}





-(void)dealData{
    if (nCount <=0) {
        return;
    }
    self.arShow = [NSMutableArray arrayWithArray:self.arImages];

    if (nCount>1) {
        [self.arShow insertObject:self.arImages.lastObject atIndex:0];//将最后一张图增加到第一张的位置
        [self.arShow addObject:self.arImages.firstObject];//将第一张图加到最后
        totalCount = nCount +2;
    }else{
        self.canAutoScroll = NO;
        self.canTunrPage = NO;
    }
    [self createImageViews];//创建视图
    
}

-(void)createImageViews{
    CGFloat pageWidth = sWidth(10.f);
    if (nCount>1) {
        for (NSInteger i = 0;i<totalCount;i++) {
            UIImageView * imgView = [self.baseScrollView viewWithTag:ImageTag + i];
            if (!imgView) {
                imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
                imgView.userInteractionEnabled = YES;
                imgView.tag = ImageTag + i;
                UIGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
                [imgView addGestureRecognizer:tapGR];
                [self.baseScrollView addSubview:imgView];
            }
            imgView.image = [UIImage imageNamed:[self.arShow objectAtIndex:i]];//
        }
       self.baseScrollView.contentSize = CGSizeMake(width * (totalCount), height);
        [self.baseScrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
        [self createTimer];//创建定时器
    }else{
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        imgView.image = [UIImage imageNamed:self.arShow.firstObject];//
        [self.baseScrollView addSubview:imgView];
    }
    if (!self.hidePageControl) {
        self.pageControl.frame = CGRectMake((width - (pageWidth * nCount))/2.f, height - sHeight(20) - sHeight(10), pageWidth * nCount, sHeight(20));
        self.pageControl.numberOfPages = nCount;
    }
}

-(void)setHidePageControl:(BOOL)hidePageControl{
    
    _hidePageControl = hidePageControl;

}

-(void)createTimer{
    
    if (self.canAutoScroll) {
        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:self.stopInterval target:self selector:@selector(timerAction)userInfo:nil repeats:YES];
            [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
    }else{
        
        if (timer) {
            [self invalidateTimer];
        }
    }
}

-(void)timerAction{
    
    [self.baseScrollView scrollRectToVisible:CGRectMake(width * (currentPage + 1), 0, width, height) animated:YES];
    
}

//- (void)turnToPage:(NSInteger)page
//{
//    [baseScrollView scrollRectToVisible:CGRectMake(width * (page + 1), 0, width, height) animated:YES];
//}

-(void)tapImageView:(UITapGestureRecognizer *)tapGR{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didClickedIndex:)]) {
        if (self.canTunrPage) {
            [self.delegate bannerView:self.baseScrollView didClickedIndex:currentPage -1];
        }else{
            
            [self.delegate bannerView:self.baseScrollView didClickedIndex:0];
        }
    }
    NSLog(@"点击了第%ld张",currentPage -1);

}

#pragma mark----------------------------滚动视图的代理方法<UIScrollViewDelegate>
//通过偏移量计算页数 实际页数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    currentPage = (scrollView.contentOffset.x + width/2.f)/width;
    if (!self.hidePageControl) {
        self.pageControl.currentPage = currentPage -1;
    }
}

#pragma mark ------------------------------------ 停止减速时判断是否是第一个或者是最后一个,处理循环问题
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.canTunrPage) {
        if (currentPage == 0) {
            [self.baseScrollView scrollRectToVisible:CGRectMake(width * totalCount, 0,width, height) animated:NO];
        }else if(currentPage == self.arShow.count -1){
            [self.baseScrollView scrollRectToVisible:CGRectMake(width, 0, width,height) animated:NO];
        }
        if (!self.hidePageControl) {
            self.pageControl.currentPage = currentPage -1;
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(bannerView:didScrollToIndex:)]) {
            [self.delegate bannerView:scrollView didScrollToIndex:currentPage -1];//由于实际比数据源的数据多序号上多1个,所以减去一个
        }
    }
}


#pragma mark ------------------------------------ 停止减速时判断是否是第一个或者是最后一个,处理循环问题
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.canTunrPage) {
        if (currentPage == 0) {
            [self.baseScrollView scrollRectToVisible:CGRectMake(width * nCount, 0,width, height) animated:NO];
        }else if(currentPage == nCount + 1){
            [self.baseScrollView scrollRectToVisible:CGRectMake(width, 0,width,height) animated:NO];
        }
    }
}


#pragma mark---------------------------- 用手拖动时释放timer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.canAutoScroll) {
        [self invalidateTimer];
    }
}

#pragma mark---------------------------- 放手后重建timer
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.canAutoScroll) {
        [self createTimer];
    }
}


#pragma mark---------------------------- 释放定时器
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

-(void)invalidateTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
@end
