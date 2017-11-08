//
//  NBRECManager.h
//  NBProject
//
//  Created by scuser on 2017/11/8.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^RecordBlock)(UIImage *movieImage);

@interface NBRECManager : NSObject
@property(nonatomic,copy)NSString * videoPath;
@property(nonatomic,strong)AVAssetWriter * writer;//
@property(nonatomic,strong)AVAssetWriterInput * videoInput;//
@property(nonatomic,strong)AVAssetWriterInput * audioInput;//

- (instancetype)initPath:(NSString*)path Height:(NSInteger)cy width:(NSInteger)cx channels:(int)ch samples:(Float64) rate;


@end
