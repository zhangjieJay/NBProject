//
//  NBShareView.h
//  NBProject
//
//  Created by 张杰 on 2018/1/10.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBShareView : UIControl
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                        image:(NSString *)imageURL
                       webUrl:(NSString *)url;

-(void)show;
@end
