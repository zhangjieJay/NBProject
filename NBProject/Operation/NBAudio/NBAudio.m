//
//  NBAudioTool.m
//  NBProject
//
//  Created by 张杰 on 2017/12/20.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface NBAudio()<AVSpeechSynthesizerDelegate>
@property(nonatomic,strong)AVSpeechSynthesizer * speaker;
@end


@implementation NBAudio

+(instancetype)shareInstance{
    
    static NBAudio * observer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (observer == nil) {
            observer = [[NBAudio alloc] initInstance];
        }
    });
    return observer;
}

/**
 *  初始化一个父类对象
 *
 *  @return 一个本类对象
 */
-(instancetype)initInstance{
    
    self = [super init];
    if (self) {
    }
    return self;
}


/**
 *  对于init方法进行处理抛出异常
 *
 */
- (instancetype)init
{
    @throw @"初始化对象失败,请采用类方法defaultObserver初始化单例对象.";
    
    return nil;
}

-(AVSpeechSynthesizer *)speaker{
    
    if (!_speaker) {
        _speaker = [AVSpeechSynthesizer new];
        _speaker.delegate= self;
    }
    return _speaker;
}
-(void)playVoiceString:(NSString *)sString{
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:sString];
    utterance.rate = 0.5;
    utterance.pitchMultiplier = 1;
    utterance.volume = 1;
    utterance.preUtteranceDelay = 1;
    utterance.postUtteranceDelay  = 1;
    AVSpeechSynthesisVoice * voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//中文
    utterance.voice = voice;
    [self.speaker speakUtterance:utterance];
    
}

//已经开始
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"开始播放");
    
}

//已经说完
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    //如果朗读要循环朗读，可以在这里再次调用朗读方法
    //    [_avSpeaker speakUtterance:utterance];
}

//已经暂停
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{}

//已经继续说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{}

//已经取消说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{}

//将要说某段话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
}

-(void)playVoice{
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
//    AudioServicesPlaySystemSound(soundID);//声音
    AudioServicesPlayAlertSound(soundID);//震动+声音
}


@end
