//
//  HeartRateVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/13.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "HeartRateVC.h"
#import <AVFoundation/AVFoundation.h>
#import "HeartRateManager.h"
#import "HeartLine.h"
#import "HeartRateManager.h"

@interface HeartRateVC ()<HeartRateManagerDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) UILabel *heartLabel;

@property (nonatomic, strong) HeartLine *heartLine;


@end

@implementation HeartRateVC

- (HeartLine *)heartLine
{
    if (!_heartLine) {
        _heartLine = [[HeartLine alloc] initWithFrame:CGRectMake(10, kScreenH-250, self.view.frame.size.width-20, 150)];
    }
    return _heartLine;
}

- (UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(kScreenW/2-50, Height_For_AppHeader+50, 100, 50);
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopButton.frame = self.startButton.frame;
        _stopButton.f_y += 80;
        [_stopButton setTitle:@"结束" forState:UIControlStateNormal];
        [_stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UILabel *)heartLabel
{
    if (!_heartLabel) {
        _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.stopButton.f_bottom+40, kScreenW, 50)];
        _heartLabel.textAlignment = NSTextAlignmentCenter;
        _heartLabel.textColor = [UIColor blackColor];
    }
    return _heartLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"心率检测";
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.heartLabel];
    [self.view addSubview:self.heartLine];
    
    [self dataConfig];
}

- (void)dataConfig
{
    [HeartRateManager shareManager].delegate = self;
}

- (void)startTest:(UIButton *)sender
{
    [[HeartRateManager shareManager] start];
}

- (void)stopTest:(UIButton *)sender
{
    [[HeartRateManager shareManager] stop];
}

#pragma mark - 测心率回调
- (void)startHeartDelegateRatePoint:(NSDictionary *)point {
    NSNumber *n = [[point allValues] firstObject];
    //拿到的数据传给心电图View
    [self.heartLine drawRateWithPoint:n];
    //NSLog(@"%@",point);
}

- (void)startHeartDelegateRateError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)startHeartDelegateRateFrequency:(NSInteger)frequency {
    NSLog(@"\n瞬时心率：%zi",frequency);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heartLabel.text = [NSString stringWithFormat:@"%ld次/分",(long)frequency];
    });
}

@end
