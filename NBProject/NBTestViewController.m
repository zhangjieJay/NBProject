
//
//  NBTestViewController.m
//  NBProject
//
//  Created by 张杰 on 2018/1/22.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBTestViewController.h"
#import "DrawView.h"

@interface NBTestViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * viewTest;//
@property(nonatomic,strong)DrawView * drawView;//

@end

@implementation NBTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cart_1"] style:UIBarButtonItemStylePlain target:self action:@selector(sjsjsjsjsjsjsj)];

    
    self.viewTest.nb_header = [NBNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"header block start");
        
    }];

//    [self.view addSubview:self.drawView];
}

-(void)sjsjsjsjsjsjsj{
    
    [self.viewTest.nb_header endRefreshing];

    
}

-(UIScrollView *)viewTest{
    
    if (!_viewTest) {
        _viewTest = [[UIScrollView alloc]init];
        _viewTest.backgroundColor = [UIColor getColorNumber:0 alph:0.5];
        _viewTest.delegate = self;
        [self.view addSubview:_viewTest];
        _viewTest.frame = self.view.bounds;
    }
    return _viewTest;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}



-(DrawView *)drawView{
    if (!_drawView) {
        _drawView = [[DrawView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        _drawView.backgroundColor = [UIColor greenColor];
        
    }
    return _drawView;
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
