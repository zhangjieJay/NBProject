//
//  NBHudView.h
//  NBProject
//
//  Created by 张杰 on 2018/1/30.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, NBHudState) {
    NBHudState_Default,/*默认状态*/
    NBHudState_Loading,/*加载状态*/
    NBHudState_Text/*显示文字提示状态*/
};

@interface NBHudView : BaseView



@end
