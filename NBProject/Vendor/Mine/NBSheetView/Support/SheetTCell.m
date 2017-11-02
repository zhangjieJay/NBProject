//
//  SheetTCell.m
//  NBProject
//
//  Created by 峥刘 on 17/8/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "SheetTCell.h"

@interface SheetTCell()

@property(nonatomic,strong)UILabel * lbDisplay;//展示的文本
@property(nonatomic,strong)CALayer * lyLine;//分割线

@end

@implementation SheetTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)lbDisplay{

    if (!_lbDisplay) {
        _lbDisplay = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, NB_SCREEN_WIDTH, 39.f)];
        _lbDisplay.textAlignment = NSTextAlignmentCenter;
        _lbDisplay.font = [NBTool getFont:15.f];
        _lbDisplay.textColor = [UIColor getColorNumber:1];
        [self.contentView addSubview:_lbDisplay];
        [self.contentView.layer addSublayer:self.lyLine];
    }
    return _lbDisplay;

}

-(CALayer *)lyLine{

    if (!_lyLine) {
        _lyLine = [CALayer layer];
        _lyLine.frame = CGRectMake(0, 39.5, NB_SCREEN_WIDTH, 0.5f);
        _lyLine.backgroundColor = [UIColor getColorNumber:10].CGColor;
    }
    return _lyLine;

}



-(void)setModel:(SheetModel *)model{

    self.lbDisplay.text = model.displayValue;
    
}

@end
