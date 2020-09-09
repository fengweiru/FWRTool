//
//  AliOSSManager.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/8.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "AliOSSManager.h"

// 单例
static AliOSSManager *manager = nil;

@interface AliOSSManager ()

@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, strong) OSSGetObjectRequest *request;
@property (nonatomic, strong) OSSPutObjectRequest *put;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableData *testData;

@end

@implementation AliOSSManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *endpoint = @"https://oss-cn-hangzhou.aliyuncs.com";
        // 移动端建议使用STS方式初始化OSSClient。
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAI4GBYyFmA14HywcLmwFo3" secretKey:@"GEsfwauoQKOttN2vv1zhYbyPWhiay9"];

        self.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    }
    return self;
}

- (void)testDownload
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(testDownloadComplete) userInfo:nil repeats:false];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    self.testData = nil;
    self.testData = [[NSMutableData alloc] init];
    
    if (self.request) {
        [self.request cancel];
        self.request = nil;
    }
    self.request = [OSSGetObjectRequest new];
    self.request.bucketName = @"test-updownload";
    self.request.objectKey = @"WPS_Office_2.6.0(4243).dmg";
    
//    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//
//    };
//    NSString *documentFilePath = NSTemporaryDirectory();
//    request.downloadToFileURL = [NSURL fileURLWithPath:documentFilePath];
    WS(weakSelf);
    self.request.onRecieveData = ^(NSData * _Nonnull data) {
//        NSLog(@"Recieve data, length: %ld", [data length]);
        [weakSelf.testData appendData:data];
    };
    OSSTask *getTask = [self.client getObject:self.request];
    
    [getTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                NSLog(@"download object success!");
                OSSGetObjectResult * getResult = task.result;
                NSLog(@"download result: %@", getResult.downloadedData);
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(downloadComplete:)]) {
                    [self.delegate downloadComplete:true];
                }
            } else {
                NSLog(@"download object failed, error: %@" ,task.error);
                if (self.delegate && [self.delegate respondsToSelector:@selector(downloadComplete:)]) {
                    [self.delegate downloadComplete:false];
                }
            }
        });

        return nil;

    }];
}

- (void)testDownloadComplete
{
    if (self.request.isCancelled == false) {
        [self.request cancel];
    }
    
    NSLog(@"testDownloadComplete result: %@", self.testData);
    
    self.request = nil;
}
- (void)testUploadComplete
{
    if (self.put.isCancelled == false) {
        [self.put cancel];
    }
    
    self.put = nil;
}

- (void)testUpload
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(testUploadComplete) userInfo:nil repeats:false];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    if (self.put) {
        [self.put cancel];
        self.put = nil;
    }
    self.put = [OSSPutObjectRequest new];
    self.put.bucketName = @"test-updownload";
    self.put.objectKey = @"tmp";
    self.put.uploadingData = self.testData;
    
    OSSTask *putTask = [self.client putObject:self.put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!task.error) {
                NSLog(@"upload object success!");
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(uploadComplete:)]) {
                    [self.delegate uploadComplete:true];
                }
            } else {
                NSLog(@"upload object failed, error: %@" , task.error);
                if (self.delegate && [self.delegate respondsToSelector:@selector(uploadComplete:)]) {
                    [self.delegate uploadComplete:false];
                }
            }
        
        });

        return nil;
    }];
}

@end
