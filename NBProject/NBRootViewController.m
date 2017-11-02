//
//  BTRootViewController.m
//  NBProject
//
//  Created by scuser on 2017/10/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRootViewController.h"
#import "NBSliderView.h"


@interface NBRootViewController ()<NBSliderViewDelegate>

@property(nonatomic,strong) UIView * aniView;

@end

@implementation NBRootViewController
@synthesize aniView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self testSliderView];
    
    
//    [self testAnimation];
    
    
}




-(void)textHudView{
    
    [NBHudProgress show];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        sleep(2);
        [NBHudProgress disMiss];
    });

}




-(void)testAnimation{

    aniView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 40.f, 40.f)];
    [aniView animateCircleRotation];
    [self.view addSubview:aniView];

}



-(void)testSliderView{
    NSArray * arTitle = @[@"全部",@"待付款",@"待收货",@"已完成",@"售后"];
    NBSliderView * sliderView = [[NBSliderView alloc]initWithFrame:CGRectMake(0, 64, NB_SCREEN_WIDTH, 45.f)];
    sliderView.arTitle = arTitle;
    sliderView.nbsv_delegate = self;
    sliderView.isAverage = YES;
    sliderView.showLine = YES;
    sliderView.showBar= YES;

    
    [self.view addSubview:sliderView];
}

-(void)sliderView:(NBSliderView *)sliderView didClickedButton:(UIButton *)sender atIndex:(NSInteger)index{

    NSLog(@"滚动到第%ld个",index);

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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

//    [aniView.layer removeAllAnimations];
    
    [self textHudView];

}

@end
