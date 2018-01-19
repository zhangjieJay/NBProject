//
//  NBShareView.m
//  NBProject
//
//  Created by 张杰 on 2018/1/10.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

typedef int32_t NBInteger;


@interface NBShareView(){
    UIView * viewContent;//显示可操作的区域
    CGFloat maxHeight;//最大高度
    NSString * _title;
    NSString * _detail;
    NSString * _webUrl;//
    NSString * _imageUrl;//图片
    NBInteger count;
    NBInteger countPerLine;
    
    BaseButton * btnTest;

}
@property(nonatomic,strong)NSMutableArray * arrBtns;//


@end



@implementation NBShareView

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
        
    }
    return self;
}
-(NSMutableArray *)arrBtns{
    
    if (!_arrBtns) {
        _arrBtns = [NSMutableArray array];
    }
    return _arrBtns;
}
- (instancetype)initWithTitle:(NSString *)title
                content:(NSString *)content
                  image:(NSString *)imageURL
                 webUrl:(NSString *)url{
    
    self = [super init];
    if (self) {
        _title = title;
        _detail = content;
        _imageUrl = imageURL;
        _webUrl = url;
        self.frame = NB_KEYWINDOW.bounds;
        self.backgroundColor = [UIColor getColorNumber:1 alph:0.4];
        [self addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventAllEvents];
        [self initUserInterface];
    }
    
    return self;
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event{
    return YES;
}

- (void)initUserInterface{
    viewContent = [UIView new];
    viewContent.backgroundColor = [UIColor getColorNumber:0];
    [self addSubview:viewContent];
    count = 6;
    countPerLine = 4;
    //内容
    NSArray *nameArr = @[@"QQ好友",@"QQ空间",@"微信",@"朋友圈",@"链接",@"其他"];
    NSArray *imageArr = @[@"QQ",@"QZone",@"Wechat",@"Wecircle",@"Link",@"other"];
    CGFloat width = NB_SCREEN_WIDTH/countPerLine;
    CGFloat height = 100.f;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        x = width * (i%countPerLine);
        y = (i / countPerLine)*height;
        BaseButton *button = [[BaseButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
        button.nb_titleType = NBButtonTypeTitle_Bottom;
        button.nb_scale = 0.7;
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor getColorNumber:115] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.arrBtns addObject:button];
        [viewContent addSubview:button];
        maxHeight = CGRectGetMaxY(button.frame);
        if (i == count -1) {
            btnTest = button;
        }
    }
    viewContent.frame = CGRectMake(0, NB_SCREEN_HEIGHT - NB_SAFE_SPACE- maxHeight, NB_SCREEN_WIDTH, maxHeight);
    
}
- (void)show{
    
    [NB_KEYWINDOW addSubview:self];
    [viewContent animateWithDuration:0.25 fromPositionY:(NB_SCREEN_HEIGHT+maxHeight/2.f) toPositionY:(NB_SCREEN_HEIGHT- NB_SAFE_SPACE -maxHeight/2.f)];
    
}

- (void)disMiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        viewContent.frame = CGRectMake(0, NB_SCREEN_HEIGHT, NB_SCREEN_WIDTH, maxHeight);
        self.backgroundColor = [[UIColor colorWithHexValue:0x000000] colorWithAlphaComponent:0.01];
    }completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

- (void)share:(UIButton *)sender{
    [sender throwToView:btnTest];
    return;
    [self disMiss];

    NSInteger index = [self.arrBtns indexOfObject:sender];
    switch (index) {
            //QQ好友
        case 0:
            [self shareWithType:SSDKPlatformTypeQQ];
            
            break;
            
            //QQ空间
        case 1:
            [self shareWithType:SSDKPlatformSubTypeQZone];
            break;
            
            //微信
        case 2:
            [self shareWithType:SSDKPlatformTypeWechat];
            break;
            
            //微信朋友圈
        case 3:
            [self shareWithType:SSDKPlatformSubTypeWechatTimeline];
            break;
            
            //复制链接
        case 4:
            [self shareWithType:SSDKPlatformTypeSinaWeibo];
            
            break;
            
            //二维码
        case 5:
            
            
            break;
            
            
            
        default:
            break;
    }
}

- (void)shareWithType:(SSDKPlatformType)type{
    
//    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//
//
//
//    }];
//
//    return;
    
    NSMutableDictionary *param = [self configurateParams];
    [param SSDKEnableUseClientShare];
    [ShareSDK share:type parameters:param onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [NBTool showMessage:@"分享成功"];
                }
                else if (state == SSDKResponseStateCancel){
                    [NBTool showMessage:@"分享取消"];
                }
                else if (state == SSDKResponseStateFail){
                    [NBTool showMessage:@"分享失败"];
                }
    }];
}
-(NSMutableDictionary *)configurateParams{
    NSURL * url = [NSURL URLWithString:Param(_webUrl)];
    NSMutableDictionary * dicParam = [NSMutableDictionary dictionary];
    [dicParam SSDKSetupShareParamsByText:_detail images:@[_imageUrl] url:url title:_title type:SSDKContentTypeAuto];
    return dicParam;
}

@end
