//
//  NBPhotoCCell.m
//  baitong_ios
//
//  Created by scuser on 2017/10/17.
//  Copyright © 2017年 syyc. All rights reserved.
//

#import "NBPhotoCCell.h"

@interface NBPhotoCCell()
@property(nonatomic,strong)UIImageView * igvHolder;
@property(nonatomic,strong)UIImageView * igvPhoto;
@property(nonatomic,strong)UIButton * btnFun;



@end

@implementation NBPhotoCCell

-(void)setModel:(EvaPhotoModel *)model{
    
    
    if (model.isAdd) {
        self.igvPhoto.image = nil;
        self.btnFun.hidden = YES;
        self.igvHolder.hidden = NO;
    }else{
        if (model.imageScaled) {
            self.igvPhoto.image = model.imageScaled;

        }else if (model.imageOriginal){
            self.igvPhoto.image = model.imageOriginal;
        }
        else{
            [self.igvPhoto sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
        }

        self.btnFun.hidden = model.hideX;
        self.igvHolder.hidden = YES;
    
    }
}

-(void)buttonClicked{
    
    if (self.nbpd_delegate && [self.nbpd_delegate respondsToSelector:@selector(didDeletePhotoAtRow:)]) {
        [self.nbpd_delegate didDeletePhotoAtRow:self.row];
    }
    
}


-(UIImageView *)igvHolder{
    if (!_igvHolder) {
        _igvHolder = [[UIImageView alloc]init];
        _igvHolder.image = [UIImage imageNamed:@"pictures"];
        [self.igvPhoto addSubview:_igvHolder];
        self.contentView.backgroundColor = [UIColor getColorNumber:25];
        [_igvHolder mas_makeConstraints:^(MASConstraintMaker *make) {

            make.edges.equalTo(self.igvPhoto);

        }];
        
    }
    return _igvHolder;
}
-(UIButton *)btnFun{

    if (!_btnFun) {
        _btnFun = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btnFun];
        [_btnFun setImage:[UIImage imageNamed:@"defeat"] forState:UIControlStateNormal];
        [_btnFun addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_btnFun mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            make.centerX.equalTo(self.igvPhoto.mas_right);
            make.centerY.equalTo(self.igvPhoto.mas_top);
        }];
    }
    return _btnFun;
}
-(UIImageView *)igvPhoto{
    if (!_igvPhoto) {
        _igvPhoto = [[UIImageView alloc]init];
        _igvPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _igvPhoto.clipsToBounds = YES;
        _igvPhoto.backgroundColor = [UIColor colorWithHexValue:0xffffff];
        [self.contentView addSubview:_igvPhoto];
        [_igvPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(5.f);
            make.top.mas_equalTo(self.contentView).offset(5.f);
            make.bottom.mas_equalTo(self.contentView).offset(-5.f);
            make.right.mas_equalTo(self.contentView).offset(-5.f);

            
        }];
        
    }
    return _igvPhoto;
}


@end
