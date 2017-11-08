//
//  NBRefreshAutoFooter.h
//  NBProject
//
//  Created by scuser on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshFooter.h"

@interface NBRefreshAutoFooter : NBRefreshFooter
/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh NBRefreshDeprecated("请使用triggerAutomaticallyRefreshPercent属性");

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
