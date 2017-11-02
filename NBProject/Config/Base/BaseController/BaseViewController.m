//
//  BaseViewController.m
//  wenzhong
//
//  Created by 峥刘 on 17/3/21.
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
    // Do any additional setup after loading the view.
    NSLog(@"-------------%@---------------视图控制器被加载",NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor getColorNumber:0];
    
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
