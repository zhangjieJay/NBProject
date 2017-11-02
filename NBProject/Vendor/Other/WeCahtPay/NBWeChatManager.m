//
//  NBWeChatManager.m
//  NBProject
//
//  Created by Jay on 17/6/28.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBWeChatManager.h"

#import "NBTool.h"
#import "WXApi.h"
#import "ApiXml.h"



/****微信支付需要的参数*****/
#define APP_ID          @"wxfec84c5dc2920695"               //APPID
#define APP_SECRET      @"5f5aadf84811d82b0d5c74c4a6591c6f" //appsecret
#define MCH_ID          @"1326913501"//商户号，填写商户对应参数
#define PARTNER_ID      @"20160401wzkfzsh20140621lzios1990"//商户API密钥，填写相应参数
#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"//支付结果回调页面

#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"//获取服务器端支付数据地址（商户自定义）
#define WXPayUrl       @"https://api.mch.weixin.qq.com/pay/unifiedorder"//获取微信服务端预付订单的接口

@interface NBWeChatManager()



@end

@implementation NBWeChatManager


+(instancetype)sharedManager{
    
    static NBWeChatManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [NBWeChatManager new];
            manager.productName = @"";
            manager.productPrice = @"";
            manager.orderNo = @"";
        }
    });
    return manager;
}



+(void)clearParams{

    [NBWeChatManager sharedManager].productName = @"";
    [NBWeChatManager sharedManager].productPrice = @"";
    [NBWeChatManager sharedManager].orderNo = @"";

}


#pragma mark -------------------------------------------------------- 本地构造微信支付信息
+(PayReq *)getPayReq{
    
    NSMutableDictionary *dict = [[NBWeChatManager sharedManager] configureOrderInfo];

    PayReq * req = nil;
    
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            req = [[PayReq alloc]init];
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
        }
    }
    
    return req;
}


#pragma mark --------------------------------------------------------1. 对原始数据进行配置处理
- (NSMutableDictionary *)configureOrderInfo{
    
    //订单标题，展示给用户
    NSString *order_name = self.productName;
    
    //订单金额,单位（分）
    NSString *prStr = self.productPrice;
    float price = 0.00;
    price = [prStr doubleValue] * 100;
    
    int priceInt = ceil(price*1.0);
    NSString *order_price = [NSString stringWithFormat:@"%d",priceInt];
    
    //================================
    //预付单参数订单设置
    //================================
    srand( (unsigned)time(0) );
    ///随机串
    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
    
    ///订单编号
    NSString *order_no   = self.orderNo;// [NSString stringWithFormat:@"%@",[self randomTradeNumber]];
    
    NSString *spbill_create_ip =[NBTool getIPAddressIsIPV4:YES];
    
    
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject: APP_ID             forKey:@"appid"];               //开放平台appid
    [packageParams setObject: MCH_ID             forKey:@"mch_id"];              //商户号
    [packageParams setObject: @"IOS"        forKey:@"device_info"];         //支付设备号或门店号
    [packageParams setObject: noncestr          forKey:@"nonce_str"];           //随机串
    [packageParams setObject: order_name        forKey:@"body"];                //订单描述，展示给用户
    [packageParams setObject: order_no           forKey:@"out_trade_no"];        //商户订单号
    [packageParams setObject: @"CNY"           forKey:@"fee_type"];        //货币类型
    [packageParams setObject: order_price       forKey:@"total_fee"];       //订单金额，单位为分
    [packageParams setObject: spbill_create_ip    forKey:@"spbill_create_ip"];  //发器支付的机器ip
    [packageParams setObject: @"APP"            forKey:@"trade_type"];          //支付类型，固定为APP
    [packageParams setObject: NOTIFY_URL            forKey:@"notify_url"];          //支付结果异步通知
    
    
    //获取prepayId（预支付交易会话标识）
    NSString *prePayid = [self sendPrepay:packageParams];
    
    if ( prePayid != nil) {
        //获取到prepayid后进行第二次签名
        
        NSString    *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str	= [NBTool MD5String:time_stamp];
        
        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
        //package       = [NSString stringWithFormat:@"Sign=%@",package];
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: APP_ID        forKey:@"appid"];
        [signParams setObject: nonce_str    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: MCH_ID        forKey:@"partnerid"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        [signParams setObject: prePayid     forKey:@"prepayid"];
        //[signParams setObject: @"MD5"       forKey:@"signType"];
        //生成签名
        NSString *sign  = [self createMd5Sign:signParams];
        
        //添加签名
        [signParams setObject:sign forKey:@"sign"];
        
        //返回参数列表
        return signParams;
        
    }else{
        
        //创建微信订单失败
        
    }
    return nil;
}



#pragma mark -------------------------------------------------------- 提交预支付订单参数
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
{
    NSString *prepayid = nil;
    
    //获取提交支付
    NSString *send = [self genPackage:prePayParams];
    
    //发送请求post xml数据
    NSData *res = [self httpSend:WXPayUrl method:@"POST" data:send];
    
    XMLHelper *xml  = [[XMLHelper alloc] init];
    
    //开始解析
    [xml startParse:res];//解析数据
    
    NSMutableDictionary *resParams = [xml getDict];//获取结果
    
    //判断返回
    NSString *return_code   = [resParams objectForKey:@"return_code"];
    NSString *result_code   = [resParams objectForKey:@"result_code"];
    if ( [return_code isEqualToString:@"SUCCESS"] )
    {
        //生成返回数据的签名
        NSString *sign = [self createMd5Sign:resParams ];
        NSString *send_sign =[resParams objectForKey:@"sign"] ;
        
        //验证签名正确性
        if( [sign isEqualToString:send_sign]){
            if( [result_code isEqualToString:@"SUCCESS"]) {
                //验证业务处理状态
                prepayid = [resParams objectForKey:@"prepay_id"];
                return_code = @"";
            }
        }else{
            
            //请求成功但是签名获取失败
        }
    }else{
        //请求失败
    }
    
    return prepayid;
}

#pragma mark -------------------------------------------------------- 获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    sign = [self createMd5Sign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}

#pragma mark -------------------------------------------------------- 创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[NBTool MD5String:contentString];
    
    return md5Sign;
}

#pragma mark -------------------------------------------------------- 生成一个随机的订单号
-(NSString *)randomTradeNumber{
    
    //时间+随机五位数
    NSString * sTrade = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    
    NSString * sDate = [dateFormatter stringFromDate:[NSDate date]];//当前时间
    NSInteger value = 10000 + arc4random()%90000;
    NSString * sNum =  [NSString stringWithFormat:@"%ld",value];//随机的一个三位数
    
    sTrade = [NSString stringWithFormat:@"%@%@%@",sTrade,sDate,sNum];
    return sTrade;
    
}



#pragma mark -------------------------------------------------------- 同步请求获取预支付订单相关信息
-(NSData *) httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    //设置提交方式
    [request setHTTPMethod:method];
    //设置数据类型
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    //设置编码
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    //如果是POST
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    //将请求的url数据放到NSData对象中
    //    NSError *error;
    //    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSData *response = [self sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return response;
}



- (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error{
    
    NSData __block *data;
    BOOL __block reqProcessed = NO;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _data, NSURLResponse * _response, NSError * _error) {
        data = _data;
        reqProcessed = YES;
    }] resume];
    
    while (!reqProcessed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];//卡线程
    }
    return data;
}


@end
