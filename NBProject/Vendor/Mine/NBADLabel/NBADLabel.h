//
//  NBADLabel.h
//  NBProject
//
//  Created by 张杰 on 2018/4/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>



@class NBADLabel;

@protocol NBADViewDelegate <NSObject>

- (void)nbChangeTextView:(NBADLabel *)autoView didTapedAtIndex:(NSInteger)index;

@end

@interface NBADLabel : UIView

@property (nonatomic, assign) id<NBADViewDelegate>delegate;
- (void)animationWithTexts:(NSArray *)textAry;
- (void)stopAnimation;

@end
