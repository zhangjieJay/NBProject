//
//  NBRemindView.h
//  NBProject
//
//  Created by Jay on 17/6/1.
//  Copyright © 2017年 Jay. All rights reserved.
//


/*
 此类功能类似于系统的UIAlertContorller,提示view需要用户进行操作.
 */

#import <UIKit/UIKit.h>

@class NBAlertView;

@protocol NBAlertViewDelegate <NSObject>

@optional

- (void)alertView:(NBAlertView *)reView clickAtIndex:(NSInteger)index;

@end

@interface NBAlertView : UIView

@property(nonatomic,assign)id<NBAlertViewDelegate>delegate;

/*默认为提示*/
/*info  为展示的信息提示
 *options 为用户可以操作的选项
 */
- (void)show:(NSString *)info;
- (void)show:(NSString *)sInfo title:(NSString *)title options:(NSArray<NSString *>*)options;

/*提示错误*/
- (void)showError:(NSString *)info;
- (void)showError:(NSString *)info options:(NSArray<NSString *>*)options;

/*提示正确*/
- (void)showSuccess:(NSString *)info;
- (void)showSuccess:(NSString *)info options:(NSArray <NSString *> *)options;






@end
