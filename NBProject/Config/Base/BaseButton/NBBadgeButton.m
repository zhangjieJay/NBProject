//
//  NBBadgeButton.m
//  NBProject
//
//  Created by 张杰 on 2018/1/19.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBBadgeButton.h"


@interface NBBadgeButton()

@property(nonatomic,strong)UILabel * lbBadge;//条数按钮

@end

@implementation NBBadgeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UILabel *)lbBadge{
    
    if (!_lbBadge) {
        _lbBadge = [UILabel new];
        _lbBadge.backgroundColor = [UIColor getColorNumber:100];
        _lbBadge.textColor = NBTEXTWCOLOR;
        _lbBadge.font = [NBTool getFont:sHeight(10) bold:YES];
        _lbBadge.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbBadge];
        [self bringSubviewToFront:_lbBadge];
        [_lbBadge nb_setAllCornerRound];
        [_lbBadge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.size.mas_greaterThanOrEqualTo(sHeight(12));
        }];
    }
    return _lbBadge;
}
-(void)updateBadge:(NSString *)sBadage{
    self.lbBadge.text = sBadage;
}
@end
