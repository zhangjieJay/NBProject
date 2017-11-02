//
//  BTRootViewController.m
//  NBProject
//
//  Created by scuser on 2017/10/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRootViewController.h"
#import "NBSliderView.h"


@interface NBRootViewController ()

@end

@implementation NBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray * arTitle = @[@"全部待付款",@"待付款",@"待收货",@"待付款已完成",@"售后",@"待付款",@"待收货",@"已完成",@"售后"];
    NBSliderView * sliderView = [[NBSliderView alloc]initWithFrame:CGRectMake(0, 64, NB_SCREEN_WIDTH, 45.f)];
    sliderView.arTitle = arTitle;
    sliderView.isAverage = NO;
    [self.view addSubview:sliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
