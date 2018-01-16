//
//  NBTextFieldCell.m
//  NBProject
//
//  Created by 张杰 on 2018/1/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBTextFieldCell.h"

@interface NBTextFieldCell()
@property(nonatomic,strong)UILabel * lbTitle;


@end

@implementation NBTextFieldCell

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
    
    
    
    self.tfInput =[[UITextField alloc]init];
    self.tfInput.textAlignment = NSTextAlignmentRight;
    self.tfInput.textColor = NBTEXTBCOLOR;
    self.tfInput.font = [NBTool getFont:15];
    [self.contentView addSubview:self.tfInput];
    

    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.tfInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.lbTitle.mas_centerY);
        make.left.mas_equalTo(self.lbTitle.mas_right).offset(10);
        
    }];


}
-(void)setModel:(ParamModel *)model{
    self.lbTitle.text = model.title;
    self.tfInput.placeholder = model.sub_title;
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
