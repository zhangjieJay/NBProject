//
//  NBShareView.h
//  baitong_ios
//
//  Created by scuser on 2017/10/14.
//  Copyright © 2017年 syyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBShareViewDelegate <NSObject>
- (void) seeDetailView;
@end

@interface NBShareView : UIView

@property (nonatomic,weak) id<NBShareViewDelegate>delegate;

- (NBShareView *)initWithTitle:(NSString *)title
                          info:(NSString *)info
                       content:(NSString *)content
                         image:(NSString *)imageURL
                        webUrl:(NSString *)url
                  normalEffect:(BOOL)isNormal;

- (NBShareView *)initWithMoney:(NSString *)money
                         title:(NSString *)title
                       content:(NSString *)content
                         image:(NSString *)imageURL
                        webUrl:(NSString *)url
                  normalEffect:(BOOL)isNormal;

- (NBShareView *)initWithCount:(NSInteger) count
                        Title:(NSString *)title
                          info:(NSString *)info
                       content:(NSString *)content
                         image:(NSString *)imageURL
                        webUrl:(NSString *)url;

-(void) showQr;
-(void)show;
@end
