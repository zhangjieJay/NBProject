//
//  NBMeViewController.m
//  NBProject
//
//  Created by 张杰 on 2018/1/11.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBMeViewController.h"
#import "NBHeaderCell.h"
#import "NBSwitchCell.h"
#import "NBTextFieldCell.h"
#import "NBTableHeader.h"

#import "NBSearchViewController.h"

@interface NBMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * mainTableView;//主视图的tableview
@property(nonatomic,strong)NSMutableArray * dataArray;//数据源
@property(nonatomic,strong)NBTableHeader * header;//tableHeader


@end

@implementation NBMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mainTableView reloadData];
    self.sticked = YES;
    self.scrollNavigationlEffectEnabled = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked)];
    
}

-(UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.estimatedRowHeight = 44;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTableView.tableHeaderView = self.header;
        [self.view addSubview:_mainTableView];
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-NB_TABBAR_HEIGHT);
        }];
    }
    return _mainTableView;
}
-(NBTableHeader *)header{
    if (!_header) {
        _header = [[NBTableHeader alloc]initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, sHeight(200))];
    }
    return _header;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        ParamModel * model0 = [ParamModel new];
        model0.title = @"进阶的巨人";
        [_dataArray addObject:model0];

        ParamModel * model1 = [ParamModel new];
        model1.title = @"消息通知";
        [_dataArray addObject:model1];
        ParamModel * model1_0 = [ParamModel new];
        model1_0.title = @"消息通知";
        [_dataArray addObject:model1_0];
        ParamModel * model1_1 = [ParamModel new];
        model1_1.title = @"消息通知";
        [_dataArray addObject:model1_1];
        ParamModel * model1_2 = [ParamModel new];
        model1_2.title = @"消息通知";
        [_dataArray addObject:model1_2];
        ParamModel * model1_3 = [ParamModel new];
        model1_3.title = @"消息通知3";
        [_dataArray addObject:model1_3];
        ParamModel * model1_4 = [ParamModel new];
        model1_4.title = @"消息通知4";
        [_dataArray addObject:model1_4];
        ParamModel * model1_5 = [ParamModel new];
        model1_5.title = @"消息通知5";
        [_dataArray addObject:model1_5];
        ParamModel * model1_6 = [ParamModel new];
        model1_6.title = @"消息通知6";
        [_dataArray addObject:model1_6];
        ParamModel * model1_7 = [ParamModel new];
        model1_7.title = @"消息通知7";
        [_dataArray addObject:model1_7];
        ParamModel * model1_8 = [ParamModel new];
        model1_8.title = @"消息通知8";
        [_dataArray addObject:model1_8];
        ParamModel * model1_9 = [ParamModel new];
        model1_9.title = @"消息通知9";
        [_dataArray addObject:model1_9];
        ParamModel * model2 = [ParamModel new];
        model2.title = @"说点什么";
        model2.sub_title = @"说点什么";
        [_dataArray addObject:model2];

    }
    return _dataArray;
}


#pragma mark ------------------------------------ Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        static NSString * cellID = @"switchCellid";
        NBSwitchCell * cell = [[NBSwitchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        ParamModel * model = [self.dataArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.model = model;
        return cell;
    }else if(indexPath.row==1){
        static NSString * cellID = @"headerCellid";
        NBHeaderCell * cell = [[NBHeaderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        ParamModel * model = [self.dataArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = model;
        return cell;
    }else{
        static NSString * cellID = @"textfieldcellid";
        NBTextFieldCell * cell = [[NBTextFieldCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        ParamModel * model = [self.dataArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.model = model;
        return cell;
    }
    

}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NBSearchViewController * searchVC = [NBSearchViewController new];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    
    CGFloat offset = scrollView.contentOffset.y;
    self.currentOffset = offset;
    [self.header updateWithOffset:offset];

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
