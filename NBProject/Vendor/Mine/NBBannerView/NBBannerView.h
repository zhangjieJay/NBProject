//
//  NBBannerView.h
//  NBProject
//
//  Created by JayZhang on 17/3/23.
//  Copyright © 2017年 none. All rights reserved.
//

/**
 *  此类未轮播滚动视图
 *
 */


#import <UIKit/UIKit.h>


@protocol NBBannerViewDelegate<NSObject>
@optional

-(void)bannerView:(UIScrollView *)scrollView didScrollToIndex:(NSInteger)index;
-(void)bannerView:(UIScrollView *)scrollView didClickedIndex:(NSInteger)index;


@end

@interface NBBannerView : UIView

@property(nonatomic,assign)CGFloat stopInterval;

- (instancetype)initWithFrame:(CGRect)frame ImageUrl:(NSArray <NSString *>*)arUrls;

@property(nonatomic,weak)id<NBBannerViewDelegate>delegate;

@property(nonatomic,assign)NSArray * arImages;//图片数组
@end
