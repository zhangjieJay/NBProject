//
//  NBPreView.m
//  NBProject
//
//  Created by 峥刘 on 17/8/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBPreView.h"
#import "PreCCell.h"


@interface NBPreView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSMutableArray * dataArray;//存放数据模型的数组
@property(nonatomic,assign)NSInteger currentIndex;//当前滚动的序号

@end
@implementation NBPreView{

    NSString * preIdentifier;//cell重用标识符

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
        preIdentifier = [NSString stringWithFormat:@"NBPreViewCollectionCellIdentifier"];
    }
    return self;
}



-(UICollectionView *)collectionView{

    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT) collectionViewLayout:layout];
        [_collectionView registerClass:[PreCCell class] forCellWithReuseIdentifier:preIdentifier];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;

}

#pragma mark -------------------------------------------------------- UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    PreCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:preIdentifier forIndexPath:indexPath];
    NSLog(@"加载第%ld个cell",indexPath.row);
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
/*开始展示cell*/
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"即将呈现第%ld个cell",indexPath.row);
    if ([cell isKindOfClass:[PreCCell class]]) {
        PreCCell * endCell = (PreCCell *)cell;
        [endCell scaledToMin];
    }

}
/*结束展示cell*/
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"结束呈现第%ld个cell",indexPath.row);
    
    if ([cell isKindOfClass:[PreCCell class]]) {
        PreCCell * endCell = (PreCCell *)cell;
        [endCell scaledToMin];
    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    
//    if (decelerate) {
//        CGFloat offset_x = scrollView.contentOffset.x;
//        NSInteger page = (self.bounds.size.width/2.f + offset_x)/self.bounds.size.width;
//        if (self.currentIndex != page) {
//            PreCCell * cell =(PreCCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//            [cell scaledToMin];
//            NSLog(@"缩放到最小");
//        }
//        self.currentIndex = page;
//    }
}




/*加载图片*/
-(void)loadImages:(NSArray *)arImage{
    
    self.dataArray = [NSMutableArray arrayWithArray:arImage];
    
    [self.collectionView reloadData];

    
}



@end
