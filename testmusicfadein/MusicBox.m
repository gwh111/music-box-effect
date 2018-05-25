//
//  MusicBox.m
//  testmusicfadein
//
//  Created by gwh on 2018/5/22.
//  Copyright © 2018年 gwh. All rights reserved.
//

#import "MusicBox.h"

@implementation MusicBox

static MusicBox *instance = nil;
static dispatch_once_t onceToken;

+ (instancetype)getInstance
{
    dispatch_once(&onceToken, ^{
        instance = [[MusicBox alloc] init];
    });
    return instance;
}

- (void)remove{
    instance=nil;
    onceToken=0;
}

- (void)playEffect:(NSString *)name type:(NSString *)type{
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:name ofType:type];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playMusic:(NSString *)name type:(NSString *)type{
    if (_audioPlayer) {
        fadeTimeCount=0;
        [self soundFadeOut:name type:type];
        return;
    }
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    [_audioPlayer setDelegate:self];
    _audioPlayer.volume = 1;
    if (_fade) {
        fadeTimeCount=0;
        _audioPlayer.volume = 0.05;
        [self soundFadeIn];
    }
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

- (void)soundFadeOut:(NSString *)name type:(NSString *)type{
    if (fadeTimeCount<10) {
        fadeTimeCount++;
        double delayInSeconds = 0.25;
        __block MusicBox *blockSelf=self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            blockSelf->_audioPlayer.volume = 1-blockSelf->fadeTimeCount*0.1;
            [self soundFadeOut:name type:type];
        });
    }else{
        [_audioPlayer stop];
        _audioPlayer=nil;
        [self playMusic:name type:type];
    }
}

- (void)soundFadeIn{
    if (fadeTimeCount<20) {
        fadeTimeCount++;
        double delayInSeconds = 0.25;
        __block MusicBox *blockSelf=self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            blockSelf->_audioPlayer.volume = blockSelf->fadeTimeCount*0.05;
            [self soundFadeIn];
        });
    }
}

//播放完后
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    if (_replayTimes>0) {
        _replayTimes--;
        [_audioPlayer play];
    }
}

@end
