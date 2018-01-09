//
//  NBNowView.m
//  NBProject
//
//  Created by 张杰 on 2018/1/8.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBPlayCenter.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
@interface NBPlayCenter()

@property(nonatomic,strong)AVAudioPlayer * player;
@end


@implementation NBPlayCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        [self configNowPlayingCenter];
    }
    return self;
}

- (void)configNowPlayingCenter {
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    [info setObject:@"哭泣吧阿根廷" forKey:MPMediaItemPropertyTitle];
    //音乐的艺术家
    NSString *author= @"邓紫棋";
    [info setObject:author forKey:MPMediaItemPropertyArtist];
    //音乐的播放时间
    [info setObject:@(120) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    //音乐的总时间
    [info setObject:@(180) forKey:MPMediaItemPropertyPlaybackDuration];
    //音乐的封面
    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"banner_01.jpeg"]];
    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
    
}

//重写父类方法，接受外部事件的处理
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"remote");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) { // 得到事件类型
                
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
                [self musicPause]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
                [self lastMusic];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
                [self nextMusic];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
                [self musicPlay];
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [self musicPause];
                break;
                
            default:
                break;
        }
    }
}
-(void)musicPause{
    [self.player pause];
}
-(void)lastMusic{

}
-(void)nextMusic{
    
}
-(void)musicPlay{
    [self.player play];
}

-(BOOL)canBecomeFirstResponder{
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
