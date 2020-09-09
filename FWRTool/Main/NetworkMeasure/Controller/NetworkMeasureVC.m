//
//  NetworkMeasureVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/25.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "NetworkMeasureVC.h"
#import "NetworkMeasure.h"
#import "AliOSSManager.h"
#import "WHPingTester.h"

typedef NS_ENUM(NSInteger, NetworkMeasureStatus) {
    NetworkMeasureStatusComplete,         //完成状态
    NetworkMeasureStatusDownload,         //下载状态
    NetworkMeasureStatusUpload,           //上传状态
};

@interface NetworkMeasureVC ()<NetworkMeasureDelegate,AliOSSManagerDelegate,WHPingDelegate>

@property (nonatomic, strong) WHPingTester *pingTester;

@property (nonatomic, assign) NetworkMeasureStatus status;

@property (nonatomic, strong) UILabel *netDelayLablel;
@property (nonatomic, strong) UILabel *downloadLabel;
@property (nonatomic, strong) UILabel *uploadLabel;

@property (nonatomic, strong) NSMutableArray *dowloadSpeedArr;
@property (nonatomic, strong) NSMutableArray *uploadSpeedArr;

@end

@implementation NetworkMeasureVC

- (NSMutableArray *)dowloadSpeedArr
{
    if (!_dowloadSpeedArr) {
        _dowloadSpeedArr = [[NSMutableArray alloc] init];
    }
    return _dowloadSpeedArr;
}
- (NSMutableArray *)uploadSpeedArr
{
    if (!_uploadSpeedArr) {
        _uploadSpeedArr = [[NSMutableArray alloc] init];
    }
    return _uploadSpeedArr;
}

- (UILabel *)netDelayLablel
{
    if (!_netDelayLablel) {
        _netDelayLablel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, kScreenW-100, 80)];
        _netDelayLablel.textAlignment = NSTextAlignmentCenter;
    }
    return _netDelayLablel;
}

- (UILabel *)downloadLabel
{
    if (!_downloadLabel) {
        _downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, kScreenW-100, 80)];
        _downloadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _downloadLabel;
}
- (UILabel *)uploadLabel
{
    if (!_uploadLabel) {
        _uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, kScreenW-100, 80)];
        _uploadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _uploadLabel;
}

- (instancetype)init
{
    if (self = [super init]) {
        [NetworkMeasure shareClient].delegate = self;
        [AliOSSManager shareManager].delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"网络测速";
    [self.view addSubview:self.netDelayLablel];
    [self.view addSubview:self.downloadLabel];
    [self.view addSubview:self.uploadLabel];
    
    self.pingTester = [[WHPingTester alloc] initWithHostName:@"www.baidu.com"];
    self.pingTester.delegate = self;
    [self.pingTester startPing];

}

- (void)didPingSucccessWithTime:(float)time withError:(NSError *)error
{
    if (!error) {
        [self.pingTester stopPing];
        self.netDelayLablel.text = [NSString stringWithFormat:@"网络延迟: %.0f ms",time];
        
        [self.dowloadSpeedArr removeAllObjects];
        self.status = NetworkMeasureStatusDownload;
        [[AliOSSManager shareManager] testDownload];
        [[NetworkMeasure shareClient] startMonitor];
    }

}

- (void)downloadComplete:(BOOL)success
{
    float avg = [[self.dowloadSpeedArr valueForKeyPath:@"@avg.floatValue"] floatValue];//求平均值
    self.downloadLabel.text = [NSString stringWithFormat:@"平均下载速度: %.0f KB/s",avg];
    
    [self.uploadSpeedArr removeAllObjects];
    self.status = NetworkMeasureStatusUpload;
    [[AliOSSManager shareManager] testUpload];
}
- (void)uploadComplete:(BOOL)success
{
    float avg = [[self.uploadSpeedArr valueForKeyPath:@"@avg.floatValue"] floatValue];//求平均值
    self.uploadLabel.text = [NSString stringWithFormat:@"平均上传速度: %.0f KB/s",avg];
    
    self.status = NetworkMeasureStatusComplete;
    [[NetworkMeasure shareClient] stopMonitor];
}

- (void)downloadSpeed:(float)downloadSpeed uploadSpeed:(float)uploadSpeed
{
    if (self.status == NetworkMeasureStatusDownload) {
        [self.dowloadSpeedArr addObject:[NSNumber numberWithFloat:downloadSpeed]];//[NSString stringWithFormat:@"%.0f",downloadSpeed]
        self.downloadLabel.text = [NSString stringWithFormat:@"下载速度: %.0f KB/s",downloadSpeed];
    } else if (self.status == NetworkMeasureStatusUpload) {
        [self.uploadSpeedArr addObject:[NSNumber numberWithFloat:uploadSpeed]];
        self.uploadLabel.text = [NSString stringWithFormat:@"上传速度: %.0f KB/s",uploadSpeed];
    }
    
}

- (void)dealloc
{
    [[NetworkMeasure shareClient] stopMonitor];
}

@end
