//
//  DecibelMeterVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/21.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "DecibelMeterVC.h"
#import <AVFoundation/AVFoundation.h>

@interface DecibelMeterVC ()
{
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
}

@property (nonatomic, strong) UILabel *describLabel;
@property (nonatomic, strong) UILabel *decibelLabel;

@end

@implementation DecibelMeterVC

- (UILabel *)describLabel
{
    if (!_describLabel) {
        _describLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader+50, kScreenW, 50)];
        _describLabel.font = FFontRegular(25);
        _describLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _describLabel;
}

- (UILabel *)decibelLabel
{
    if (!_decibelLabel) {
        _decibelLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2-40, self.describLabel.f_bottom+100, 80, 80)];
        _decibelLabel.font = FFontRegular(30);
        _decibelLabel.backgroundColor = CommonBlueColor;
        _decibelLabel.textColor = [UIColor whiteColor];
        _decibelLabel.textAlignment = NSTextAlignmentCenter;
        
        _decibelLabel.layer.masksToBounds = true;
        _decibelLabel.layer.cornerRadius = _decibelLabel.f_height/2;
    }
    return _decibelLabel;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [levelTimer invalidate];
    levelTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分贝仪";
    
    [self.view addSubview:self.describLabel];
    [self.view addSubview:self.decibelLabel];
    [self startTest];
}

- (void)startTest
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    
    /* 不需要保存录音文件 */
       NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
       
       NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                                 [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                 [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                 [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                                 nil];
       
       NSError *error;
       recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
       if (recorder)
       {
           [recorder prepareToRecord];
           recorder.meteringEnabled = YES;
           [recorder record];
           levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
       }
       else
       {
           NSLog(@"%@", [error description]);
       }
}

/* 该方法确实会随环境音量变化而变化，但具体分贝值是否准确暂时没有研究 */
- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // use -80db Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 5.0f; //modified level from 2.0 to 5.0 is neast to real test
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"voice updated :%f",level * 120);
        NSInteger dB = level * 120;
        
        self.decibelLabel.text = [NSString stringWithFormat:@"%zidB",dB];
        NSString *string = @"";
        if (dB <= 20) {
            string = @"很静、几乎感觉不到";
        } else if (dB <= 40) {
            string = @"安静、犹如轻声絮语";
        } else if (dB <= 60) {
            string = @"一般、普通室内谈话";
        } else if (dB <= 70) {
            string = @"吵闹、有损神经";
        } else if (dB <= 90) {
            string = @"很吵、神经细胞受到破坏";
        } else if (dB <= 100) {
            string = @"吵闹加剧、听力受损";
        } else if (dB < 120) {
            string = @"难以忍受、呆一分钟即暂时致聋";
        } else if (dB >= 120) {
            string = @"极度聋或全聋";
        }
        
        self.describLabel.text = string;
    });
}

- (void)dealloc{
    if (recorder) {
        [recorder stop];
        recorder = nil;
    }
}

@end
