//
//  BannerView.m
//  allKindsOfTest
//
//  Created by 峥刘 on 17/3/23.
//  Copyright © 2017年 none. All rights reserved.
//

#import "BannerView.h"
#define ImageTag 20000
@interface BannerView ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray * arShow;
@property(nonatomic,assign)BOOL canAutoScroll;//能否自动滑动
@property(nonatomic,assign)BOOL canTunrPage;//是否能够翻页
@end


@implementation BannerView{
    
    NSArray * parUrls;
    UIScrollView * baseScrollView;
    NSInteger nCount;
    NSInteger totalCount;
    
    NSTimer * timer;
    NSInteger currentPage;
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

- (instancetype)initWithFrame:(CGRect)frame ImageUrl:(NSArray <NSString *>*)arUrls
{
    self = [super initWithFrame:frame];
    if (self) {
        parUrls = arUrls;
        width = frame.size.width;
        height = frame.size.height;
        nCount = arUrls.count;
        [self createControls];
        [self dealData];//处理数据
        
    }
    return self;
}
-(void)initDefultParams{
    
    _stopInterval = 2.f;
    
    
}

-(void)createControls{
    baseScrollView  = [[UIScrollView alloc]initWithFrame:self.bounds];
    baseScrollView.delegate = self;
    baseScrollView.bounces = YES;
    baseScrollView.pagingEnabled = YES;
    baseScrollView.showsHorizontalScrollIndicator = NO;
    baseScrollView.showsVerticalScrollIndicator = NO;//不显竖向滚动条
    [self addSubview:baseScrollView];
}

-(void)dealData{
    if (nCount <=0) {
        return;
    }
    self.arShow = [NSMutableArray arrayWithArray:parUrls];
    
    if (nCount>1) {
        self.canAutoScroll = YES;
        self.canTunrPage = YES;
        [self.arShow insertObject:parUrls.lastObject atIndex:0];//将最后一张图增加到第一张的位置
        [self.arShow addObject:parUrls.firstObject];//将第一张图加到最后
        totalCount = nCount +2;
    }
    [self createImageViews];//创建视图
    
}

-(void)createImageViews{
    
    if (nCount>1) {
        for (NSInteger i = 0;i<totalCount;i++) {
            UIImageView * imgView = [baseScrollView viewWithTag:ImageTag + i];
            if (!imgView) {
                imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
                imgView.userInteractionEnabled = YES;
                imgView.tag = ImageTag + i;
                UIGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
                [imgView addGestureRecognizer:tapGR];
                [baseScrollView addSubview:imgView];
            }
            imgView.image = [UIImage imageNamed:[self.arShow objectAtIndex:i]];//
        }
        baseScrollView.contentSize = CGSizeMake(width * (totalCount), height);
        [baseScrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
        [self createTimer];//创建定时器
    }else{
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        imgView.image = [UIImage imageNamed:self.arShow.firstObject];//
        [baseScrollView addSubview:imgView];
    }
    
}



-(void)createTimer{
    
    if (self.canAutoScroll) {
        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:2.f target:self selector:@selector(timerAction)userInfo:nil repeats:YES];
            [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
    }else{
        
        if (timer) {
            [self invalidateTimer];
        }
    }
}

-(void)timerAction{
    
    [baseScrollView scrollRectToVisible:CGRectMake(width * (currentPage + 1), 0, width, height) animated:YES];
    
}

//- (void)turnToPage:(NSInteger)page
//{
//    [baseScrollView scrollRectToVisible:CGRectMake(width * (page + 1), 0, width, height) animated:YES];
//}

-(void)tapImageView:(UITapGestureRecognizer *)tapGR{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didClickedIndex:)]) {
        if (self.canTunrPage) {
            [self.delegate bannerView:baseScrollView didClickedIndex:currentPage -1];
            
        }else{
            
            [self.delegate bannerView:baseScrollView didClickedIndex:0];
        }
    }
}

#pragma mark----------------------------滚动视图的代理方法<UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    currentPage = (scrollView.contentOffset.x + width/2.f)/width;
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.canTunrPage) {
        if (currentPage == 0) {
            [baseScrollView scrollRectToVisible:CGRectMake(width * totalCount, 0,width, height) animated:NO];
        }else if(currentPage == self.arShow.count -1){
            [baseScrollView scrollRectToVisible:CGRectMake(width, 0, width,height) animated:NO];
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(bannerView:didScrollToIndex:)]) {
            
            [self.delegate bannerView:scrollView didScrollToIndex:currentPage -1];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.canTunrPage) {
        if (currentPage == 0) {
            [baseScrollView scrollRectToVisible:CGRectMake(width * nCount, 0,width, height) animated:NO];
        }else if(currentPage == nCount + 1){
            [baseScrollView scrollRectToVisible:CGRectMake(width, 0,width,height) animated:NO];
        }
    }
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.canAutoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.canAutoScroll) {
        [self createTimer];
    }
}


#pragma mark----------------------------解决野指针问题
- (void)dealloc {
    baseScrollView.delegate = nil;
}
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
