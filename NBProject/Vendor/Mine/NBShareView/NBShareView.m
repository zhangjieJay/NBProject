//
//  NBShareView.m
//  baitong_ios
//
//  Created by scuser on 2017/10/14.
//  Copyright © 2017年 syyc. All rights reserved.
//

#import "NBShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
#import <RennSDK/RennSDK.h>


@interface NBShareView(){

    UIView *viewBg;
    NSString *_title;//标题
    NSString *_info;//
    NSString *_earnMoney;//赚取金额
    NSString *_content;//文本
    NSString *_webURL;//网页连接
    NSString *_imgURL;//图片URL
    CGFloat maxHeight;
    BOOL _isDefaultBgView;//是否是普通背景,默认为遮罩
    UIButton *_qrBtn;
    UILabel *_naLabel;
    NSInteger _count;
}
@property (nonatomic, strong)NSMutableArray *btnArr;

@end

@implementation NBShareView

- (void)dealloc {
    NSLog(@"分享视图释放了");
}
    
- (NBShareView *)initWithCount:(NSInteger)count
                         Title:(NSString *)title
                          info:(NSString *)info
                       content:(NSString *)content
                         image:(NSString *)imageURL
                        webUrl:(NSString *)url{
    self = [super init];
    if (self) {
        _count = count;
        _title = title;
        _info = info;
        _content = content;
        _imgURL = imageURL;
        _webURL = url;
        [self initUserInterface];
    }

    return self;
}

/**
 *  分享需要的创建的视图
 *
 *  @param title          分享的标题
 *  @param content        分享的内容说明
 *  @param imageURL       分享的图片地址
 *  @param url            点击后的页面跳转地址
 *  @param isNormal 是否需要遮罩效果
 *
 *  @return 分享视图
 */
- (NBShareView *)initWithTitle:(NSString *)title
                          info:(NSString *)info
                       content:(NSString *)content
                         image:(NSString *)imageURL
                        webUrl:(NSString *)url
                  normalEffect:(BOOL)isNormal{
    
    self = [super init];
    if (self) {
        _count = 6;
        _title = title;
        _info = info;
        _content = content;
        _imgURL = imageURL;
        _webURL = url;
        _isDefaultBgView = isNormal;
        [self initUserInterface];
    }
    return self;
    
    
}


- (NBShareView *)initWithMoney:(NSString *)money
                         title:(NSString *)title
                       content:(NSString *)content
                         image:(NSString *)imageURL
                        webUrl:(NSString *)url
                  normalEffect:(BOOL)isNormal{

    self = [super init];
    if (self) {
        _count = 6;
        _title = title;
        _earnMoney = money;
        _content = content;
        _imgURL = imageURL;
        _webURL = url;
        _isDefaultBgView = isNormal;
        [self initUserInterface];
    }
    return self;
}

- (NBShareView *)init;
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface{
    
    //self
    self.frame = CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT);
    self.backgroundColor = [[UIColor colorWithHexValue:0x000000] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    [self addGestureRecognizer:tapGR];

    
    viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT)];
    viewBg.backgroundColor = [UIColor colorWithHexValue:0xffffff];
    [self addSubview:viewBg];
    //maxY
    maxHeight = 0.f;;
    CGFloat tempY = 0.f;

    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40.f, NB_SCREEN_WIDTH, 20.f)];
    titleLabel.center = CGPointMake(NB_SCREEN_WIDTH / 2, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_earnMoney) {
        titleLabel.text = [NSString stringWithFormat:@"赚¥%@",[NBTool decimalNumber:_earnMoney]];
        titleLabel.font = [NBTool getFont:18.f];
        titleLabel.textColor = [UIColor getColorNumber:300];
        
        UILabel * lbDescript = [[UILabel alloc] init];
        lbDescript.numberOfLines = 0;
        lbDescript.textAlignment = NSTextAlignmentCenter;

        lbDescript.font = [NBTool getFont:14.f];
        NSString * text = @"只要您的好友通过您的链接购买此产品,您就能赚取到至少";
        NSMutableAttributedString * spre = [NBTool getmuAttributedString:text font:14.f textColor:[UIColor getColorNumber:1]];
        NSAttributedString * mid = [NBTool getAttributedString:[NBTool decimalNumber:_earnMoney] font:14.f textColor:[UIColor getColorNumber:600]];
        [spre appendAttributedString:mid];
        NSString * tail = @"元的利润哦";
        mid = [NBTool getAttributedString:tail font:14.f textColor:[UIColor getColorNumber:400]];
        [spre appendAttributedString:mid];
        
        text = [NSString stringWithFormat:@"%@%@%@",text,[NBTool decimalNumber:_earnMoney],tail];
        
        CGSize size = [NBTool autoString:text font:[NBTool getFont:14.f] width:(NB_SCREEN_WIDTH - 50.f)];
        
        
        
        lbDescript.attributedText = spre;
        lbDescript.frame = CGRectMake(25.f, CGRectGetMaxY(titleLabel.frame)+15.f, NB_SCREEN_WIDTH - 50.f, size.height);
        [viewBg addSubview:lbDescript];
        tempY = CGRectGetMaxY(lbDescript.frame);
        
    }else{
    
        titleLabel.text = _info;
        titleLabel.textColor = [UIColor getColorNumber:1];
        titleLabel.font = [NBTool getFont:17.f];
        tempY = CGRectGetMaxY(titleLabel.frame);
    }
    
    [viewBg addSubview:titleLabel];
    
    
    
    //内容
    NSArray *nameArr = @[@"QQ好友",
                         @"QQ空间",
                         @"微信",
                         @"朋友圈",
                         @"链接",
                         @"其他"];
    NSArray *imageArr = @[@"QQ",
                          @"QZone",
                          @"Wechat",
                          @"Wecircle",
                          @"Link",
                          @"other"];
    
    int space = 25.f;//间隔
    int buttonWidth = (NB_SCREEN_WIDTH - (space * 5)) / 4;
    for (int i = 0; i < _count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(space + (i % 4) * (space + buttonWidth), tempY + (15.f) + (i / 4) * (buttonWidth + (40.f)), buttonWidth, buttonWidth)];
        [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [viewBg addSubview:button];
        [self.btnArr addObject:button];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + (5.f), buttonWidth + (10), (20))];
        nameLabel.center = CGPointMake(button.center.x, nameLabel.center.y);
        nameLabel.text = nameArr[i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font =  [NBTool getFont:12.f];
        nameLabel.textColor = [UIColor getColorNumber:1];
        [viewBg addSubview:nameLabel];
        if (i == nameArr.count - 1) {
            button.hidden = YES;
            nameLabel.hidden = YES;
            
            _naLabel = nameLabel;
            _qrBtn = button;
        }
        maxHeight = CGRectGetMaxY(nameLabel.frame);
        
        
    }
    
    
    //分割线
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight + (20.f), NB_SCREEN_WIDTH, 1)];
    separatorView.backgroundColor = [UIColor getColorNumber:1];
    [viewBg addSubview:separatorView];
    
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(separatorView.frame), NB_SCREEN_WIDTH, (50.f))];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor getColorNumber:1] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor getColorNumber:1] forState:UIControlStateHighlighted];

    [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexValue:0xffffff]] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor getColorNumber:1]] forState:UIControlStateHighlighted];

    cancelButton.titleLabel.textColor = [UIColor getColorNumber:1];
    cancelButton.titleLabel.font = [NBTool getFont:18.f];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:cancelButton];
    
    maxHeight = CGRectGetMaxY(cancelButton.frame);
    //设置自身大小
    viewBg.frame = CGRectMake(0, NB_SCREEN_HEIGHT-maxHeight, NB_SCREEN_WIDTH, maxHeight);
    
}
- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [viewBg animateWithDuration:0.25 fromPositionY:(NB_SCREEN_HEIGHT+maxHeight/2.f) toPositionY:(NB_SCREEN_HEIGHT-maxHeight/2.f)];
    
}

- (void)disMiss{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        viewBg.frame = CGRectMake(0, NB_SCREEN_HEIGHT, NB_SCREEN_WIDTH, maxHeight);
        self.backgroundColor = [[UIColor colorWithHexValue:0x000000] colorWithAlphaComponent:0.01];

    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)cancelButtonClick{
    [self disMiss];
}


- (void)share:(UIButton *)sender{
    [self disMiss];
    NSInteger index = [self.btnArr indexOfObject:sender];
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
    NSMutableDictionary *param = [self configurateWithType:type];
    [ShareSDK share:type parameters:param onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            [ZY_Util showMessage:@"分享成功"];
//        }
    }];
}

#pragma mark ------------------------------------ 复制到剪贴板
-(void)copyLinkToBoard{
    
    if (_webURL) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _webURL;
        [NBTool showMessage:@"复制链接成功"];
    }

}
#pragma mark ------------------------------------ 构造shareSDK需要的参数
- (NSMutableDictionary *)configurateWithType:(SSDKPlatformType)type {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    SSDKContentType contentType = SSDKContentTypeAuto;//默认分享的为文本类型
    [param SSDKSetupShareParamsByText:_content images:@[_imgURL,_imgURL.copy] url:[NSURL URLWithString:_webURL] title:_title type:contentType];
    return param;
}

#pragma mark ------------------------------------ getter
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

/**
 *  点击背景视图隐藏分享视图
 *
 *  @param tapGR tap手势
 */
-(void)HideView:(UITapGestureRecognizer*)tapGR{
    
    [self disMiss];
}


/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
