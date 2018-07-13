//
//  NBPhotoView.m
//  NBProject
//
//  Created by 张杰 on 2018/5/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBPhotoView.h"
#import "NBPhotoCCell.h"
#import "EvaPhotoModel.h"
@interface NBPhotoView()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NBPhotoCellDeleteDelegate,NBPhotoChangedDelegate>

@property(nonatomic,strong)UICollectionView * albumCollectionView;
@property(nonatomic,strong)NSMutableArray * photoModelsArray;
@property(nonatomic,assign)CGFloat maxWidth;//最大宽度
@property(nonatomic,assign)CGFloat itemsWidth;//每个cell宽度
@property(nonatomic,assign)CGFloat gap;//缝隙

@property(nonatomic,weak)EvaPhotoModel * addModel;//新增的model



@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)NSInteger line;
@end

@implementation NBPhotoView{
    
    NSString * refusedCellIdentifier;//Cell
    NSInteger countPerLine;//每行多少个
    
}

-(NSMutableArray *)photoModelsArray{
    if (!_photoModelsArray) {
        _photoModelsArray = [NSMutableArray array];
        EvaPhotoModel * modelAdd = [EvaPhotoModel new];
        self.addModel = modelAdd;
        modelAdd.isAdd = YES;
        [_photoModelsArray addObject:modelAdd];
    }
    return _photoModelsArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWidth = frame.size.width;
        self.maxCount = 6;
        self.gap= 10;
        [self.albumCollectionView reloadData];
        [self calculateLines];
    }
    return self;
}

-(void)calculateLines{
    
    self.line = (self.photoModelsArray.count + countPerLine-1)/countPerLine;
    if (self.line>(self.maxCount/countPerLine)) {
        self.line = self.maxCount/countPerLine;
    }
    self.albumCollectionView.frame = CGRectMake(0, 0, self.maxWidth, (self.line+1)*self.gap+(self.itemsWidth * self.line));
    CGRect rect = self.frame ;
    rect.size.height = self.albumCollectionView.frame.size.height;
    self.frame = rect;
}


-(UICollectionView *)albumCollectionView{
    
    if (!_albumCollectionView) {
        refusedCellIdentifier = [NSString stringWithFormat:@"GoodTtttPhotorefusedCellIdentifier"];
        countPerLine = 3;
        self.itemsWidth = ((self.maxWidth - self.gap*2.f)- (countPerLine - 1) * self.gap)/countPerLine;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(self.itemsWidth, self.itemsWidth);
        layout.minimumLineSpacing = self.gap;
        layout.minimumInteritemSpacing = self.gap;
        _albumCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _albumCollectionView.contentInset = UIEdgeInsetsMake(self.gap, self.gap, self.gap, self.gap);
        [_albumCollectionView registerClass:[NBPhotoCCell class] forCellWithReuseIdentifier:refusedCellIdentifier];
        _albumCollectionView.backgroundColor = [UIColor grayColor];
        _albumCollectionView.bounces = NO;
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        [self addSubview:self.albumCollectionView];
    }
    return _albumCollectionView;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger totalCount = self.photoModelsArray.count;
    return totalCount>self.maxCount?self.maxCount:totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NBPhotoCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:refusedCellIdentifier forIndexPath:indexPath];
    cell.nbpd_delegate = self;
    EvaPhotoModel * model = [self.photoModelsArray objectAtIndex:indexPath.row];
    cell.row = indexPath.row;
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<self.photoModelsArray.count) {
        EvaPhotoModel * model = [self.photoModelsArray objectAtIndex:indexPath.row];
        if (model.isAdd) {
            [self chooseImageSourceType];
        }
    }
}
//#pragma mark ------------------------------------ 图片选择后回传
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
//    [self valueToModelsWithImages:photos];
//
//}
#pragma mark ------------------------------------ 相机拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSArray * arImage = [NSArray arrayWithObject:image];
    [self valueToModelsWithImages:arImage];
}


-(void)valueToModelsWithImages:(NSArray *)photos{
    
    
    
    
    for (NSInteger i = 0; i<photos.count; i++) {
        EvaPhotoModel * model = [EvaPhotoModel new];
        model.imageOriginal = [photos objectAtIndex:i];
        NSInteger index = [self.photoModelsArray indexOfObject:self.addModel];

        if (index == 0) {
            [self.photoModelsArray insertObject:model atIndex:0];
        }else{
            
            [self.photoModelsArray insertObject:model atIndex:index];

        }
    }
    

    [self calculateLines];
    [self.albumCollectionView reloadData];
    
}


-(void)didDeletePhotoAtRow:(NSInteger)row{
    if (row<self.photoModelsArray.count) {
        EvaPhotoModel * model = [self.photoModelsArray objectAtIndex:row];
        [self.photoModelsArray removeObject:model];
        [self calculateLines];
        [self.albumCollectionView reloadData];
    }
    
    
}


#pragma mark ------------------------------------ 打开相册或者相机
-(void)chooseImageSourceType{
    __weak typeof(self) weakSelf = self;
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * acLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openPhotosLibrary];
    }];
    
    UIAlertAction * acCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf penCamera];
    }];
    
    UIAlertAction * acCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:acLibrary];
    [alertVC addAction:acCamera];
    [alertVC addAction:acCancel];
    [self.target presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark ------------------------------------ 打开相册
-(void)openPhotosLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount-self.photoModelsArray.count-1 delegate:self];
//        imagePickerVc.allowPickingVideo = NO;
//        [self.target presentViewController:imagePickerVc animated:YES completion:nil];

    }else{
        NSLog(@"相册权限不足");
    }
}
#pragma mark ------------------------------------ 打开相机
-(void)penCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.target presentViewController:imagePicker animated:YES completion:nil];
    }else{
        NSLog(@"相机不可用");
    }
}


@end

