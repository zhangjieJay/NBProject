//
//  NBPhotoView.h
//  NBProject
//
//  Created by 张杰 on 2018/5/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseView.h"

@protocol NBPhotoChangedDelegate<NSObject>
@optional

@end
@interface NBPhotoView : BaseView
@property(nonatomic,assign)NSInteger maxCount;
@property(nonatomic,weak)UIViewController * target;//主要用于推出视图控制器

@end
