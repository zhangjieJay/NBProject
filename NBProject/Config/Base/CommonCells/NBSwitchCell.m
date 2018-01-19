//
//  NBSwitchCell.m
//  NBProject
//
//  Created by 张杰 on 2018/1/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBSwitchCell.h"
@interface NBSwitchCell()
@property(nonatomic,strong)UILabel * lbTitle;//
@property(nonatomic,strong)UISwitch * switchControl;

@end

@implementation NBSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    //必须在创建第一块控件的时候约束：contentView
    //重点】必须在创建最后一块控件的时候约束：contentView
    self.lbTitle = [NBTool createLableFont:[NBTool getFont:15.f bold:YES] textColor:[UIColor getColorNumber:1]];
    [self.contentView addSubview:self.lbTitle];
    
    
    self.switchControl =[UISwitch new];
    [self.switchControl addTarget:self action:@selector(valuechanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchControl];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(self.switchControl.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.centerY.equalTo(self.lbTitle.mas_centerY);
    }];
}

-(void)setModel:(ParamModel *)model{
    self.lbTitle.text = model.title;
}
-(void)setSwitchOn:(BOOL)isOn{
    [self.switchControl setOn:isOn animated:YES];
}

-(void)valuechanged:(UISwitch *)sender{
    
    if (self.nbsw_delegate && [self.nbsw_delegate respondsToSelector:@selector(clickSwitch:isOn:)]) {
            [self.nbsw_delegate clickSwitch:sender isOn:sender.isOn];
    }

}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

