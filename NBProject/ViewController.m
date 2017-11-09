//
//  ViewController.m
//  NBProject
//
//  Created by 峥刘 on 17/6/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TestViewController.h"
#import "NBPreView.h"
#import "NBSliderView.h"
#import "QRCodeViewController.h"
@interface ViewController ()

@property(nonatomic,strong)UIView * fffview;


@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor getColorNumber:610];
    [self initControls];
}

- (void)initControls{
    
    self.fffview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 400)];
    self.fffview.backgroundColor= [UIColor getColorNumber:1];
    [self.view addSubview:self.fffview];

    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"增加" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor getColorNumber:100] forState:UIControlStateNormal];

    btn.frame = CGRectMake(100, 100,120, 40);
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    NSArray * arTitle = @[@"全部",@"待付款",@"待收货",@"已完成",@"售后",@"待付款",@"待收货",@"已完成",@"售后"];
    NBSliderView * sliderView = [[NBSliderView alloc]initWithFrame:CGRectMake(0, 500, NB_SCREEN_WIDTH, 45.f)];
    sliderView.arTitle =arTitle;
    [self.view addSubview:sliderView];
    
//
//    
//    
//    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setTitle:@"删除" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor getColorNumber:105] forState:UIControlStateNormal];
//    
//    btn1.frame = CGRectMake(100, 200,120, 40);
//    [btn1 setBackgroundColor:[UIColor blueColor]];
//    [btn1 addTarget:self action:@selector(clicked1:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
//    
//    
//    
//    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setTitle:@"修改" forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor getColorNumber:110] forState:UIControlStateNormal];
//    
//    btn2.frame = CGRectMake(100, 300,120, 40);
//    [btn2 setBackgroundColor:[UIColor blueColor]];
//    [btn2 addTarget:self action:@selector(clicked2:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn2];
//    
//    
//    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn3 setTitle:@"查询" forState:UIControlStateNormal];
//    [btn3 setTitleColor:[UIColor getColorNumber:120] forState:UIControlStateNormal];
//    
//    btn3.frame = CGRectMake(100, 400,120, 40);
//    [btn3 setBackgroundColor:[UIColor blueColor]];
//    [btn3 addTarget:self action:@selector(clicked3:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn3];
    
}


-(void)clicked:(UIButton *)sender{
    
    
//    QRCodeViewController * qrVC = [QRCodeViewController new];
//    
//    [self presentViewController:qrVC animated:YES completion:nil];
    
    
    ImageModel * model = [ImageModel new];
    model.imageName = @"beauty.jpg";
    
    ImageModel * model1 = [ImageModel new];
    model1.imageName = @"pig.jpeg";
    
    ImageModel * model2 = [ImageModel new];
    model2.imageName = @"long.png";
    
    ImageModel * model3 = [ImageModel new];
    model3.imageName = @"rabbit.jpeg";
    
    NSArray * array = [NSArray arrayWithObjects:model,model1,model2,model3,nil];
    NBPreView * pre = [NBPreView new];
    [pre animateWithDuration:0.25 fromPositionX:NB_SCREEN_WIDTH+NB_SCREEN_WIDTH/2.f toPositionX:NB_SCREEN_WIDTH/2.f];
    [pre loadImages:array];
    [self.view addSubview:pre];
    
    

//    NSDictionary *dict = @{@"action":@"loginM",
//                           @"mobile":@"310003",
//                           @"password":@"123456"};
//    
//    
//    [NBNetWork postToUrl:@"http://www.wzxfyl.com/mobileservice/AppInvokeService.ashx" param:dict success:^(id obj) {
//        
//        [NBTool showMessage:@"请求成功"];
//        
//    } failure:^(NSString *error) {
//        
//        
//    }];
    
    
    
//    [[NBSQLManager sharedManager] open];
//
//    [[NBSQLManager sharedManager] createTable:@"temp" columnParams:@"autoNo integer primary key autoincrement,name text,sex text"];
//    [[NBSQLManager sharedManager] insertIntoTable:@"temp" cloumn:@"name,sex" values:@"'runner','male'"];
//
//    [[NBSQLManager sharedManager] close];

    
    

}

-(void)clicked1:(UIButton *)sender{
    [[NBSQLManager sharedManager] open];
    [[NBSQLManager sharedManager] deleteFromTable:@"temp" condition:@"name = 'new'"];
    [[NBSQLManager sharedManager] close];
    
}


-(void)clicked2:(UIButton *)sender{
    [[NBSQLManager sharedManager] open];
    [[NBSQLManager sharedManager] updateTable:@"temp" value:@"name = 'new'" condition:@"name = 'runner'"];
    [[NBSQLManager sharedManager] close];

}



-(void)clicked3:(UIButton *)sender{
    [[NBSQLManager sharedManager] open];
    NSArray * arr = [[NBSQLManager sharedManager] queryInTable:@"temp" column:@"name,sex,autoNo" condition:@"name = 'new'"];
    NSLog(@"%@",arr);
    NSString * str = [arr componentsJoinedByString:@"-"];
    NBAlertView * aler = [[NBAlertView alloc]init];
    [aler showSuccess:str];
    [[NBSQLManager sharedManager] close];

}


@end
