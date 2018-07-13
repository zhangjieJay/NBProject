//
//  NBPhotoCCell.h
//  baitong_ios
//
//  Created by scuser on 2017/10/17.
//  Copyright © 2017年 syyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaPhotoModel.h"

@protocol NBPhotoCellDeleteDelegate <NSObject>

@optional

-(void)didDeletePhotoAtRow:(NSInteger)row;

@end
@interface NBPhotoCCell : UICollectionViewCell

@property(nonatomic,assign)id<NBPhotoCellDeleteDelegate>nbpd_delegate;
@property(nonatomic,strong)EvaPhotoModel * model;
@property(nonatomic,assign)NSInteger row;

@end
