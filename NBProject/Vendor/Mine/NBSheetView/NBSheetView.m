//
//  NBSheetView.m
//  NBProject
//
//  Created by 峥刘 on 17/8/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBSheetView.h"
#import "SheetTCell.h"


@interface NBSheetView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView * sheetTable;//表格视图
@property(nonatomic,strong)NSMutableArray * dataArray;//数据数组

@end

@implementation NBSheetView{

    NSString * sheetCellIdentifier;
    CGRect tableFrame;//表格视图的高度  需要经过model数量确认
    
    CGFloat cellHeight;//cell高度(默认高度40),如果修改,请修改cell中控件的frame
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = [NBTool getColorNumber:-1];
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tapGR.delegate =self;
        [self addGestureRecognizer:tapGR];
        [self initBaseData];
    }
    return self;
}

-(void)initBaseData{
    
    sheetCellIdentifier = [NSString stringWithFormat:@"NBSheetViewCellIdentifier"];
    cellHeight = 40.f;
    
}

-(UITableView *)sheetTable{

    if (!_sheetTable) {
        _sheetTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NB_SCREEN_HEIGHT, NB_SCREEN_WIDTH, tableFrame.size.height)];//创建时在屏幕外部,通过动画
        _sheetTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_sheetTable registerClass:[SheetTCell class] forCellReuseIdentifier:sheetCellIdentifier];
        
        _sheetTable.scrollEnabled = NO;
        _sheetTable.delegate = self;
        _sheetTable.dataSource = self;
        [self addSubview:_sheetTable];
        
    }
    return _sheetTable;
}

-(void)showWithArray:(NSArray *)arData{
    
    if (arData.count >= 1) {

        CGFloat height = 40.f * arData.count;
        tableFrame = CGRectMake(0, NB_SCREEN_HEIGHT - height, NB_SCREEN_WIDTH, height);
        [NB_KEYWINDOW addSubview:self];
        self.dataArray = [NSMutableArray arrayWithArray:arData];
        [self.sheetTable reloadData];
        [self show];
    }else{
        NSLog(@"数据模型为空");
    }
}
#pragma mark -------------------------------------------------------- TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SheetTCell * cell = [tableView dequeueReusableCellWithIdentifier:sheetCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SheetModel * model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;//cell高度
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SheetModel * model = [self.dataArray objectAtIndex:indexPath.row];

    if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(didSelectAtIndex:key:value:)]) {
        [self.sDelegate didSelectAtIndex:indexPath.row key:model.key value:model.value];
    }
    [self hide];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //若果点击的view是自己则响应时间 否则不响应touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"NBSheetView"]) {
        return YES;
    }else{
        return NO;
    }

}


-(void)show{

    [UIView animateWithDuration:0.25f animations:^{//改变
        
        self.sheetTable.frame = tableFrame;
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [[NBTool getColorNumber:1] colorWithAlphaComponent:0.6];//动画完成后设置背景颜色

    }];

}


-(void)hide{
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.sheetTable.frame = CGRectMake(0, NB_SCREEN_HEIGHT, NB_SCREEN_WIDTH, tableFrame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


@end
