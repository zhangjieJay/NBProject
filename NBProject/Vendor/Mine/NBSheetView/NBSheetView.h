//
//  NBSheetView.h
//  NBProject
//
//  Created by JayZhang on 17/8/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "BaseView.h"

@protocol NBSheetViewDelegate <NSObject>

@optional

-(void)didSelectAtIndex:(NSInteger)index key:(NSString *)key value:(NSString *)value;

@end

@interface NBSheetView : BaseView
@property(nonatomic,weak)id<NBSheetViewDelegate>sDelegate;
-(void)showWithArray:(NSArray *)arData;//mark 数组中存放的是SheetModel对象


@end
