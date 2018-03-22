//
//  NBNormalHeader.h
//  NBProject
//
//  Created by 张杰 on 2018/1/25.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBRefreshHeader.h"

@interface NBNormalHeader : NBRefreshHeader
@property (weak, nonatomic, readonly) UIActivityIndicatorView * loadingView;

@end
