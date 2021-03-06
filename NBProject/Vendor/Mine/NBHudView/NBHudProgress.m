//
//  NBHudView.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/4/28.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "NBHudProgress.h"
#import "BaseView.h"
#import "NBLoadingView.h"


typedef NS_ENUM(NSInteger){
    
    NBHudProgressType_Loading,//加载
    
    NBHudProgressType_Success,//成功
    
    NBHudProgressType_Error,//出错
//    
//    NBHudProgressType_Center,//
//    
//    NBHudProgressType_Top //
    
}NBHudProgressType;





@interface NBHudProgress()



/**底部透明视图,遮挡作用,防止loading过程中点击发生意外**/
@property(nonatomic,strong)BaseView * backView;

/**中间放置LoadingView或igvStatus及lbText**/
@property(nonatomic,strong)BaseView * statusView;

/***加载的视图**/
@property(nonatomic,strong)NBLoadingView * loadingView;


/**用来显示成功或者失败的图片提示(不能与loadingView并存)**/
@property(nonatomic,strong)UIImageView * igvStatus;

/**文字提示的标签**/
@property(nonatomic,strong)UILabel * lbText;

@property(nonatomic,assign)CGRect currentFrame;//当前视图的最大尺寸
@property(nonatomic,assign)NBHudProgressType hud_Type;
@end

@implementation NBHudProgress
{
    CGRect rectStatu;//
    UIFont * textFont;//标签字体
    CGFloat gap; //缝隙
    CGFloat aferDelay;//延迟执行之间
}

#pragma mark -------------------------------- 懒加载
- (BaseView*)backView
{
    if (!_backView) {
        _backView = [[BaseView alloc]init];
        _backView.backgroundColor = [UIColor getColorNumber:-1];

    }
    return _backView;
}


- (BaseView*)statusView
{
    if (!_statusView) {
        _statusView = [[BaseView alloc]initWithFrame:CGRectMake(0, 0, 80.f, 80.f)];
        _statusView.backgroundColor = [UIColor getColorNumber:0];
        [self.backView addSubview:_statusView];
    }
    return _statusView;
}


- (NBLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[NBLoadingView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loadingView.backgroundColor = [UIColor getColorNumber:-1];
        [self.statusView addSubview:_loadingView];

    }
    return _loadingView;
}

- (UIImageView *)igvStatus
{
    if (!_igvStatus) {
        _igvStatus = [[UIImageView alloc]init];
        [self.statusView addSubview:_igvStatus];
    }
    return _igvStatus;
}

- (UILabel *)lbText
{
    if (!_lbText) {
        _lbText = [[UILabel alloc]init];
        _lbText.numberOfLines = 0;
        _lbText.textAlignment = NSTextAlignmentCenter;
        _lbText.textColor = [UIColor getColorNumber:0];
        _lbText.font = textFont;
        [self.statusView addSubview:_lbText];
    }
    return _lbText;
}




#pragma mark -------------------------------- 单例方法
+(instancetype)shareInstance
{
    static NBHudProgress * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[NBHudProgress alloc] initSelfObject];
        }
    });
    return instance;
}
#pragma mark -------------------------------- 禁止使用init
- (instancetype)init
{
    @throw @"请使用+shareInstance方法进行初始化";
}


#pragma mark -------------------------------- 自定义初始化方法
- (instancetype)initSelfObject
{
    self = [super init];
    if (self) {
        gap = 10.f;aferDelay = 1.5f;
        textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.f];
        if (!textFont) {
            textFont = [UIFont boldSystemFontOfSize:15.f];
        }
        
    }
    return self;
}

#pragma mark -------------------------------- 外部可用方法
+ (void)show
{
    [NBHudProgress showInView:NB_KEYWINDOW];
}

+ (void)showInView:(UIView *)view
{
    [NBHudProgress showInView:view text:nil];
}


+ (void)showInView:(UIView *)view text:(NSString *)text
{
    [[NBHudProgress shareInstance] layoutControlsInView:view text:text image:nil type:NBHudProgressType_Loading];
}


+ (void)showText:(NSString *)text
{
    [[NBHudProgress shareInstance] layoutControlsInView:[NBTool getForfontWindow] text:text image:nil type:NBHudProgressType_Loading];
}


+ (void)showSuccessText:(NSString *)text
{
    [NBHudProgress showSuccessText:text inView:[NBTool getForfontWindow]];
}

+ (void)showSuccessText:(NSString *)text inView:(UIView *)view
{
    [[NBHudProgress shareInstance] layoutControlsInView:view text:text image:[UIImage imageNamed:@"NB_completed_icon"] type:NBHudProgressType_Success];
}


+ (void)showErrorText:(NSString *)text{
    
    [NBHudProgress showErrorText:text inView:[NBTool getForfontWindow]];
}

+ (void)showErrorText:(NSString *)text inView:(UIView *)view
{
    [[NBHudProgress shareInstance] layoutControlsInView:view text:text image:[UIImage imageNamed:@"NB_error_icon"] type:NBHudProgressType_Error];
}


#pragma mark -------------------------------- 子控件的初始化及定位处理
- (void)layoutControlsInView:(UIView *)view text:(NSString *)text image:(UIImage *)image type:(NBHudProgressType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeAllSubviewInView:self.backView];
    
        [NBHudProgress shareInstance].hud_Type = type;
        self.currentFrame = view.bounds;//将当前frame置为最大
        self.backView.frame = self.currentFrame;//
        [view addSubview:self.backView];
        [self.backView addSubview:self.statusView];
        
        
        
        /***计算statusview的尺寸并居中****/
        CGFloat heightLoad = 40.f;
        CGFloat maxWidth = 120.f;
        CGSize size = text?[NBTool autoString:text font:textFont width:maxWidth height:50]:CGSizeZero;//计算statusView的宽度
        CGFloat statusWidth = text?MAX(heightLoad, size.width)+gap * 2.f:heightLoad + gap*2.f;
        CGFloat statusHeight =text?heightLoad+gap*3.f+size.height:heightLoad+gap*2.f;
        
        CGFloat lineWidth = MAX(statusWidth, statusHeight);
        self.statusView.frame = CGRectMake(0, 0, lineWidth, lineWidth);
        self.statusView.center = self.backView.center;
        [self.statusView nb_setAllCornerWithCornerRadius:5.f];
        [self.statusView animateWithDuration:0.25 fromScale:0.1 toScale:1.2];
   
        /***根据各种烈性****/
        switch (type) {
            case NBHudProgressType_Loading:
                self.igvStatus.hidden = YES;
                self.loadingView.hidden = NO;
                self.loadingView.frame = CGRectMake((lineWidth-heightLoad)/2.f, gap, heightLoad, heightLoad);
                [self.loadingView startLoading];
                
                
                break;
            case NBHudProgressType_Success:
            case NBHudProgressType_Error:
                self.igvStatus.hidden = NO;
                self.loadingView.hidden = YES;
                [self.loadingView endLoading];
                self.igvStatus.frame = CGRectMake((lineWidth-heightLoad)/2.f, gap, heightLoad, heightLoad);
                self.igvStatus.image = image;
                [self performSelector:@selector(disMissSelf) withObject:nil afterDelay:aferDelay];
                
                break;
            default:
                break;
        }
        
        self.lbText.text = text;
        if (text) {
            self.lbText.text = text;
            self.lbText.frame = CGRectMake((lineWidth-size.width)/2.f, heightLoad + gap +(lineWidth - heightLoad - gap -size.height)/2.f, size.width, size.height);
            self.statusView.backgroundColor = [[UIColor getColorNumber:1] colorWithAlphaComponent:0.4];
            
        }else{
            self.lbText.text = nil;
            self.statusView.backgroundColor = [UIColor getColorNumber:-1] ;
            
        }
    });
    

    
}

#pragma mark -------------------------------- 移除NBHudProgress
- (void)disMissSelf
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.backView removeFromSuperview];
        self.backView =nil;
        self.loadingView.hidden = YES;
    });

}

+ (void)disMiss{
    
    [[NBHudProgress shareInstance] disMissSelf];

}

#pragma mark --------------------------------递归删除子视图
- (void)removeAllSubviewInView:(UIView *)superView
{
    [self.backView removeFromSuperview];
    self.backView =nil;
    
}

@end
