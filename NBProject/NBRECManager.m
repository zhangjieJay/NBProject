//
//  NBRECManager.m
//  NBProject
//
//  Created by JayZhang on 2017/11/8.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRECManager.h"

@interface NBRECManager()

@property(nonatomic,copy)RecordBlock block;

@end

@implementation NBRECManager
//初始化方法
- (instancetype)initPath:(NSString*)path Height:(NSInteger)cy width:(NSInteger)cx channels:(int)ch samples:(Float64) rate {
    self = [super init];
    if (self) {
        self.videoPath = path;
        //先把路径下的文件给删除掉，保证录制的文件是最新的
        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
        NSURL* url = [NSURL fileURLWithPath:self.videoPath];
        //初始化写入媒体类型为MP4类型
        _writer = [AVAssetWriter assetWriterWithURL:url fileType:AVFileTypeMPEG4 error:nil];
        //使其更适合在网络上播放
        _writer.shouldOptimizeForNetworkUse = YES;
        //初始化视频输出
        [self initVideoInputHeight:cy width:cx];
        //确保采集到rate和ch
        if (rate != 0 && ch != 0) {
            //初始化音频输出
            [self initAudioInputChannels:ch samples:rate];
        }
    }
    return self;
}

//初始化视频输入
- (void)initVideoInputHeight:(NSInteger)cy width:(NSInteger)cx {
    //录制视频的一些配置，分辨率，编码方式等等
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              AVVideoCodecH264, AVVideoCodecKey,//编码方式
                              [NSNumber numberWithInteger: cx], AVVideoWidthKey,//宽像素
                              [NSNumber numberWithInteger: cy], AVVideoHeightKey,//高像素
                              nil];
    //初始化视频写入类
    _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
    //表明输入是否应该调整其处理为实时数据源的数据
    _videoInput.expectsMediaDataInRealTime = YES;
    //将视频输入源加入
    [_writer addInput:_videoInput];
}

//初始化音频输入
- (void)initAudioInputChannels:(int)ch samples:(Float64)rate {
    //音频的一些配置包括音频各种这里为AAC,音频通道、采样率和音频的比特率
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,//
                              [NSNumber numberWithInt:ch], AVNumberOfChannelsKey,//音频的音频通道
                              [NSNumber numberWithFloat:rate], AVSampleRateKey,//音频的采样率
                              [NSNumber numberWithInt:128000], AVEncoderBitRateKey,//音频的比特率
                              nil];
    //初始化音频写入类
    _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    //表明输入是否应该调整其处理为实时数据源的数据
    _audioInput.expectsMediaDataInRealTime = YES;
    //将音频输入源加入
    [_writer addInput:_audioInput];
    
}


@end
