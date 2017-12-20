//
//  BTRootViewController.m
//  NBProject
//
//  Created by JayZhang on 2017/10/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRootViewController.h"
#import "NBSliderView.h"

#import "NBRECViewController.h"
#import "NBBannerView.h"


@interface NBRootViewController ()<NBSliderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView * mainTableView;



@end

@implementation NBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString * name = [NBDevice getDeviceName];
    
    
    self.navigationItem.title =@"嘿嘿";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"点击" style:UIBarButtonItemStylePlain target:self action:@selector(dosomething)];
    
    self.view.backgroundColor = [UIColor getColorNumber:0];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor getColorNumber:0] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.mainTableView];
    // Do any additional setup after loading the view.
    
    NBBannerView * banner = [[NBBannerView alloc]init];
    banner.stopInterval = 4.f;
    banner.frame = CGRectMake(0, 0, NB_SCREEN_WIDTH, 200);
    NSArray * arImages = @[@"banner_01.jpeg",@"banner_02.jpeg",@"banner_03.jpeg",@"banner_04.jpeg"];
    banner.arImages = arImages;
    [self.view addSubview:banner];

}


-(void)dosomething{

    [self.navigationController showViewController:[NBRECViewController new] sender:nil];

}

-(void)textHudView{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView.nb_header endRefreshing];
            [self.mainTableView.nb_footer endRefreshingWithNoMoreData];

        });

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
        WEAKSELF
        CGRect rect = self.view.bounds;
        rect.size.height = NB_SCREEN_HEIGHT- 64-200;
        rect.origin.y = 200;
        _mainTableView =[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        NBRefreshNormalHeader * header = [NBRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf textHudView];
        }];
        _mainTableView.nb_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;

        
        
        NBRefreshAutoNormalFooter * footer = [NBRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf textHudView];

        }];
        [footer setTitle:@"~~~~~~~~~~我是有底线的~~~~~~~~~~" forState:NBRefreshStateNoMoreData];
        [footer setTitle:@"拼命加载中..." forState:NBRefreshStateRefreshing];

        _mainTableView.nb_footer = footer;
        
        
        

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
    
    return 20;
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
    
//    [self startREC];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alphHeight = 200;
    CGFloat alpoffset = fabs(scrollView.contentOffset.y);
    CGFloat alp = alpoffset/alphHeight;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor getColorNumber:0] colorWithAlphaComponent:alp]] forBarMetrics:UIBarMetricsDefault];
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



-(void)startREC{

    NBRECViewController * recVC = [NBRECViewController new];
    [self.navigationController pushViewController:recVC animated:YES];
    
    



}



@end
