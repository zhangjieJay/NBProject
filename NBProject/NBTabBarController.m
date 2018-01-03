//
//  NBTabBarController.m
//  NBProject
//
//  Created by JayZhang on 2017/11/9.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBTabBarController.h"
#import "NBCustomTabBar.h"
#import "NBViewControllerAnimation.h"
@interface NBTabBarController ()<UITabBarDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)NBCustomTabBar * customBar;//


@end

@implementation NBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customBar.hidden = NO;
    
}


-(NBCustomTabBar *)customBar{
    @try {
        if (!_customBar) {
            _customBar = [[NBCustomTabBar alloc]initWithFrame:CGRectZero];
            [self setValue:_customBar forKey:@"tabBar"];
            NSArray * arCls = @[@"NBRootViewController",/*@"NBRECViewController",*/@"QRCodeViewController"];
            NSArray * arTitles = @[@"首页",@"摄像视图",@"二维码扫描"];
            NSArray * arImagesNormal = @[@"classify_1",@"cart_1",@"home_1"];
            NSArray * arImagesSelected = @[@"classify_2",@"cart_2",@"home_2"];
            
            
            for (NSInteger i = 0; i<arCls.count; i++) {
                Class cls = NSClassFromString(arCls[i]);
                if ([cls isSubclassOfClass:[BaseViewController class]]) {
                    BaseViewController *vc = [[cls alloc] init];
                    vc.title = arTitles[i];
                    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:vc];
                    navi.delegate =self;
                    [navi.tabBarItem setImage:[UIImage imageNamed:arImagesNormal[i]]];
                    [navi.tabBarItem setSelectedImage:[UIImage imageNamed:arImagesSelected[i]]];
                    navi.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -3.5);
                    [self addChildViewController:navi];
                }
            }
            
        }
        return _customBar;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }

}

#pragma mark ------------------------------------ UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}

#pragma mark ------------------------------------ 给点击的添加动画
- (void)animationWithIndex:(NSInteger) index {
    
    NSMutableArray * arImageViews = [NSMutableArray array];
    for (UIView *tempView in self.tabBar.subviews) {
        if ([tempView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {//找到tabbar
            for (UIView * temp in tempView.subviews) {
                if ([temp isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {//还有一个UITabBarButtonLabel目前未用到
                    [arImageViews addObject:temp];
                }
            }
        }
    }
    
    if (index<arImageViews.count) {
        UIView * view = [arImageViews objectAtIndex:index];
        CASpringAnimation* animation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
        animation.damping =10;
        animation.initialVelocity=0;
        animation.mass = 1;
        animation.stiffness = 500;
        animation.duration = 1;
        animation.fromValue= [NSNumber numberWithFloat:0.8];
        animation.toValue= [NSNumber numberWithFloat:1];
        [[view layer] addAnimation:animation forKey:nil];
    }

}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{

    /**
     
     *  typedef NS_ENUM(NSInteger, UINavigationControllerOperation) {
     
     *     UINavigationControllerOperationNone,
     
     *     UINavigationControllerOperationPush,
     
     *     UINavigationControllerOperationPop,
     
     *  };
     
     */
    //push的时候用我们自己定义的customPush
    if (operation == UINavigationControllerOperationPush) {
        
        return [NBViewControllerAnimation new];
        
    }else{
        
        return nil;
        
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
