//
//  NBHeaderCell.m
//  NBProject
//
//  Created by 张杰 on 2018/1/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBHeaderCell.h"

@interface NBHeaderCell()
@property(nonatomic,strong)UIImageView * igvHeader;
@property(nonatomic,strong)UILabel * lbTitle;//
@end

@implementation NBHeaderCell

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
    
    
    self.igvHeader =[UIImageView new];
    [self.igvHeader nb_setAllCornerRound];
    [self.contentView addSubview:self.igvHeader];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(self.igvHeader.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.igvHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.lbTitle.mas_centerY);
    }];
}

-(void)setModel:(ParamModel *)model{
    
    self.lbTitle.text = model.title;
    self.igvHeader.image = [UIImage imageNamed:@"icon_WeiXin"];
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
