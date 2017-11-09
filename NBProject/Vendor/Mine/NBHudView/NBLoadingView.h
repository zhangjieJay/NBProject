//
//  NBLoadingView.h
//  wenzhong
//
//  Created by JayZhang on 17/5/12.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "BaseView.h"

@interface NBLoadingView : BaseView
@property(nonatomic,strong)UIColor * mainColor;//颜色

/**开始转动**/
-(void)startLoading;

/**停止转动**/
-(void)endLoading;



@end
