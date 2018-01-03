//
//  BTWebViewController.m
//  baitong_ios
//
//  Created by scuser on 2017/10/25.
//  Copyright © 2017年 syyc. All rights reserved.
//

#import "NBWebViewController.h"
#import <WebKit/WebKit.h>
//#import <WKWebViewJavascriptBridge.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface NBWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)WKWebView *webView;
//@property(nonatomic,strong)WKWebViewJavascriptBridge *brige;
@property(nonatomic,strong)UIProgressView * progressView;
@property(nonatomic,strong)NSDictionary * dicButton;//按钮数据
@property(nonatomic,strong)NSDictionary * dicShare;//分享数据

@end

@implementation NBWebViewController


-(void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view.
    [self initNavigationView];
    if (!self.sLinkUrl) {
        if (self.sHtmlString) {
            [self.webView loadHTMLString:self.sHtmlString baseURL:nil];
        }
    }else{
        [self configParams];
//        self.brige = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//        [self.brige setWebViewDelegate:self];
//
//        [self.brige registerHandler:@"saveImage" handler:^(id data, WVJBResponseCallback responseCallback) {
//
//        }];
        
    }
}

#pragma mark ------------------------------------ 初始化导航栏
-(void)initNavigationView{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked)];

    
}

-(void)backBarButtonClicked{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        [self.webView reload];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




-(WKWebView *)webView{
    
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc]init];
        config.preferences.javaScriptEnabled = YES;
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT - NB_NAVI_HEIGHT) configuration:config];
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
//        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
        [_webView addSubview:self.progressView];
    }
    
    return _webView;
}



#pragma mark ------------------------------------ 配置参数
-(void)configParams{
    
    /*创建*/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.sLinkUrl]];
/***********配置cookie**************/
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        [cookieDic setObject:cookie.value forKey:cookie.name];
//    }
//
//    if ([WMJUserManager sharedManager].selectAccessToken.access_token.length != 0) {
//        [cookieDic setObject:[WMJUserManager sharedManager].selectAccessToken.user_id forKey:@"user_id"];
//        [cookieDic setObject:[WMJUserManager sharedManager].selectAccessToken.access_token forKey:@"access_token"];
//        [cookieDic setObject:@"ios" forKey:@"device_type"];
//
//        NSMutableString * cookieValue =[NSMutableString string];
//        // cookie重复，先放到字典进行去重，再进行拼接
//        for (NSString *key in cookieDic) {
//            NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
//            [cookieValue appendString:appendString];
//        }
//        [request addValue:cookieValue forHTTPHeaderField: @"Cookie"];
//    }
/***********配置cookie**************/

    
    [self.webView loadRequest: request];
    
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
}



- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    self.navigationItem.title = webView.title;
    
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error.code == -999) {
        return;
    }
    self.navigationItem.title = @"加载错误";
    
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
}

-(UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, 2)];
        _progressView.progressViewStyle =UIProgressViewStyleDefault;
        _progressView.tintColor = [UIColor getColorNumber:500];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progress =0.1;
        _progressView.hidden = YES;
    }
    return _progressView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark--进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            NSLog(@"%f",newprogress);
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
