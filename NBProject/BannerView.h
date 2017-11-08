//
//  BannerView.h
//  allKindsOfTest
//
//  Created by 峥刘 on 17/3/23.
//  Copyright © 2017年 none. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BannerViewScrollDelegate<NSObject>
@optional

-(void)bannerView:(UIScrollView *)scrollView didScrollToIndex:(NSInteger)index;
-(void)bannerView:(UIScrollView *)scrollView didClickedIndex:(NSInteger)index;


@end

@interface BannerView : UIView

@property(nonatomic,assign)CGFloat stopInterval;

- (instancetype)initWithFrame:(CGRect)frame ImageUrl:(NSArray <NSString *>*)arUrls;

@property(nonatomic,assign)id<BannerViewScrollDelegate>delegate;


@end
