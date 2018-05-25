//
//  ViewController.m
//  testmusicfadein
//
//  Created by gwh on 2018/5/22.
//  Copyright © 2018年 gwh. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicBox.h"

@interface ViewController ()<AVAudioPlayerDelegate>{
    AVAudioPlayer *audioPlayer;
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [MusicBox getInstance].fade=YES;
    [MusicBox getInstance].replayTimes=2;
    [[MusicBox getInstance]playMusic:@"战斗2" type:@"mp3"];
    
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[MusicBox getInstance]playEffect:@"女再见1" type:@"mp3"];
    });
    
    {
        double delayInSeconds = 6;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[MusicBox getInstance]playMusic:@"周杰伦这所有的一切" type:@"mp3"];
        });
    }
}




@end
