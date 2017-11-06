//
//  BTRootViewController.m
//  NBProject
//
//  Created by scuser on 2017/10/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRootViewController.h"
#import "NBSliderView.h"


@interface NBRootViewController ()<NBSliderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView * mainTableView;



@end

@implementation NBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor getColorNumber:125];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor getColorNumber:0] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.title = @"测试";
    
    
    [self.view addSubview:self.mainTableView];
    // Do any additional setup after loading the view.
    
//    [self testSliderView];
    [self.mainTableView reloadData];
    CGSize size = self.mainTableView.contentSize;
    
    
}




-(void)textHudView{
    
    [NBHudProgress showInView:self.view text:@"加载中..."];
    CGSize size = self.mainTableView.contentSize;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        sleep(2);
        [NBHudProgress showErrorText:@"请求失败"];

    });

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



-(UITableView *)mainTableView{
    
    if (!_mainTableView) {
//        _mainTableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 100, NB_SCREEN_WIDTH, 100) style:UITableViewStyleGrouped];

        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_mainTableView];
        
    }
    
    return _mainTableView;
}
#pragma mark ------------------------------------ tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    

    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self textHudView];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alphHeight = 200;
    CGFloat alpoffset = fabs(scrollView.contentOffset.y);
    CGFloat alp = alpoffset/alphHeight;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor getColorNumber:500] colorWithAlphaComponent:alp]] forBarMetrics:UIBarMetricsDefault];
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
    
    NSArray * ar = self.navigationController.navigationBar.subviews;
    
    
    for (UIView * view in ar) {
        NSLog(@"类名:%@",NSStringFromClass([view class]));
        
    }
    

}

@end
