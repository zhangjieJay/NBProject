//
//  NBSearchViewController.m
//  NBProject
//
//  Created by 张杰 on 2018/5/30.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBSearchViewController.h"
#import "UISearchPageViewController.h"

@interface NBSearchViewController ()<UISearchBarDelegate,UISearchControllerDelegate>
@property(nonatomic,strong)UISearchController * searchVC;
@end

@implementation NBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor getColorNumber:0];
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchVC;
        [self.searchVC.searchBar setPlaceholder:@"搜索"];
        self.navigationItem.hidesSearchBarWhenScrolling = YES;
//        [self.searchVC.searchBar setPositionAdjustment:UIOffsetMake((NB_SCREEN_WIDTH-100)/2, 0) forSearchBarIcon:UISearchBarIconSearch];

    } else {
        [self.view addSubview:self.searchVC.searchBar];

    }
}

-(UISearchController *)searchVC{
    if (!_searchVC) {
        UISearchPageViewController * pageVC =[UISearchPageViewController new];
        _searchVC = [[UISearchController alloc]initWithSearchResultsController:pageVC];
        _searchVC.searchResultsUpdater = pageVC;
//        _searchVC.dimsBackgroundDuringPresentation = YES;
//        _searchVC.obscuresBackgroundDuringPresentation = YES;
//        _searchVC.hidesNavigationBarDuringPresentation = NO;
        [_searchVC.searchBar sizeToFit];
        _searchVC.delegate = self;
    }
    return _searchVC;
}


- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog_Method;
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog_Method;

}
- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog_Method;

}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog_Method;

}
- (void)presentSearchController:(UISearchController *)searchController{
    NSLog_Method;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
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
