//
//  PreCCell.h
//  NBProject
//
//  Created by JayZhang on 17/8/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

@interface PreCCell : UICollectionViewCell

@property(nonatomic,strong)ImageModel * model;//图片模型

-(void)scaledToMin;

@end
