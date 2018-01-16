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

@interface NBMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * mainTableView;//主视图的tableview
@property(nonatomic,strong)NSMutableArray * dataArray;//数据源

@end

@implementation NBMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mainTableView reloadData];
}


-(UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.estimatedRowHeight = 44;

        [self.view addSubview:_mainTableView];
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _mainTableView;
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
    NBAlertView * alert = [NBAlertView new];
    [alert show:@"你即将开始旅行?" title:@"完了" options:@[@"取消",@"知道了"]];
    
    
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
