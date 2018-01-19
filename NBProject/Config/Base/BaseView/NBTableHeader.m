//
//  NBTableHeader.m
//  NBProject
//
//  Created by 张杰 on 2018/1/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBTableHeader.h"
@interface NBTableHeader()
@property(nonatomic,strong)UIImageView * igvBack;
@property(nonatomic,strong)UIImageView * igvHeader;


@end
@implementation NBTableHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
   return  [self initWithFrame:CGRectZero];

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.igvBack.clipsToBounds = YES;
        self.igvHeader.hidden = NO;
    }
    return self;
}

-(UIImageView *)igvHeader{
    
    if (!_igvHeader) {
        _igvHeader = [[UIImageView alloc]init];
        _igvHeader.contentMode = UIViewContentModeScaleAspectFill;
        _igvHeader.image = [UIImage imageNamed:@"banner_01.jpeg"];
        [self addSubview:_igvHeader];
        [_igvHeader nb_setAllCornerRound];
        [_igvHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sWidth(10));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.height.mas_equalTo(sWidth(50));
        }];
    }
    return _igvHeader;
}

-(UIImageView *)igvBack{
    
    if (!_igvBack) {
        _igvBack = [[UIImageView alloc]init];
        _igvBack.contentMode = UIViewContentModeScaleAspectFill;
        _igvBack.layer.anchorPoint = CGPointMake(0.5, 1);
        _igvBack.image = [UIImage imageNamed:@"pig.jpeg"];
        [self addSubview:_igvBack];
        _igvBack.frame = self.bounds;
    }
    return _igvBack;
}


-(void)updateWithOffset:(CGFloat)offset{

    if (offset<0) {
        CGFloat scale  = (1+ fabs(offset)/200);
        self.igvBack.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);

    }else{
        self.igvBack.transform = CGAffineTransformIdentity;

    }

}

@end
