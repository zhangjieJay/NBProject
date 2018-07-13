//
//  BaseViewController.m
//  wenzhong
//
//  Created by JayZhang on 17/3/21.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


-(void)dealloc{
    
    NSLog(@"-------------%@---------------视图控制器被释放",NSStringFromClass([self class]));
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.normarlNavigationColor = [UIColor redColor];//[UIColor getColorNumber:515];
    self.effectNavigationColor = [UIColor blackColor];//NBTEXTBCOLOR;
    NSLog_Method
    // Do any additional setup after loading the view.
    NSLog(@"-------------%@---------------视图控制器被加载",NSStringFromClass([self class]));
    
    self.view.backgroundColor = [UIColor getColorNumber:0];
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog_Method
    [super viewWillAppear:animated];
    [self updateStickState];
    [self setupNavigationWithOffset:self.currentOffset];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self updateStickState];
}



#pragma mark ------------------------------- 初始化导航栏
-(void)initNavigation{
    UIImage *image = [UIImage imageNamed:@"back"];//[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked)];
}



-(void)backBarButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showNavigationSeperator{
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:NBSEPCOLOR]];
}
-(void)hideNavigationSeperator{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)asignSeparatorColor:(UIColor *)color{
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:color]];
}

-(void)enabledTranslucentBackground{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor getColorNumber:-1 alph:0.5]] forBarPosition:0 barMetrics:0];
}
-(void)unabledTranslucentBackground{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NBAPPCOLOR] forBarPosition:0 barMetrics:0];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    [self setupNavigationWithOffset:offset];
}

-(void)setupNavigationWithOffset:(CGFloat)offset{
    
    if (self.scrollNavigationlEffectEnabled) {
        
        if (offset>0) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NBAPPCOLOR] forBarPosition:0 barMetrics:0];
            [self.navigationController.navigationBar setTintColor:self.effectNavigationColor];

        }else{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor getColorNumber:-1]] forBarPosition:0 barMetrics:0];
            [self.navigationController.navigationBar setTintColor:self.normarlNavigationColor];


        }
    }else{
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NBAPPCOLOR] forBarPosition:0 barMetrics:0];

    }
    
}


-(void)setSticked:(BOOL)sticked{
    _sticked = sticked;
    [self updateStickState];
}
-(void)updateStickState{
    if (self.isSticked) {
//        self.navigationController.navigationBar.translucent = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;//无偏移
        [self hideNavigationSeperator];
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }else{
//        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;//有偏移
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        [self showNavigationSeperator];
    }
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
