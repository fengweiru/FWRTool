//
//  ProtractorVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/17.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ProtractorVC.h"
#import "ProtractorView.h"

#import <AVFoundation/AVFoundation.h>

@interface ProtractorVC ()<ProtractorViewDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) ProtractorView *protractor;

@property (nonatomic, strong) UILabel *angleLabel;

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ProtractorVC

- (ProtractorView *)protractor
{
    if (!_protractor) {
        _protractor = [[ProtractorView alloc] initWithFrame:CGRectMake(30, Height_For_AppHeader+20, kScreenW-100, (kScreenW-100)*2+40)];
        _protractor.delegate = self;
    }
    return _protractor;
}

- (UILabel *)angleLabel
{
    if (!_angleLabel) {
        _angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-120, Height_For_AppHeader+80, 120, 50)];
        _angleLabel.textColor = CommonBlueColor;
        _angleLabel.font = FFontRegular(30);
        _angleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_angleLabel setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    }
    return _angleLabel;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.frame = CGRectMake(kScreenW-100, kScreenH-Height_For_IphoneBottom-100, 50, 50);
        [_cameraButton setImage:[UIImage imageNamed:@"camera-blue"] forState:UIControlStateNormal];
        _cameraButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cameraButton setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    }
    return _cameraButton;
}

- (AVCaptureSession *)session
{
    if (!_session) {
        NSError *error = nil;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//设备
        _session = [[AVCaptureSession alloc] init];//捕捉会话
        [_session setSessionPreset:AVCaptureSessionPresetHigh];//设置采集率
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];//输入流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];//输出流
        //添加到捕捉会话
        [_session addInput:input];
        [_session addOutput:output];
        //扫码类型：需要先将输出流添加到捕捉会话后再进行设置
        //这里只设置了可扫描二维码,有条码需要，在数组中继续添加即可
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        //输出流delegate,在主线程刷新UI
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];//预览
        _videoPreviewLayer.frame = CGRectMake(0, Height_For_AppHeader, self.view.bounds.size.width, kScreenH-Height_For_AppHeader);
        [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];//添加预览图层
        //还可以设置扫描范围 output.rectOfInterest  不设置默认为全屏
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"量角器";
    
    [self.view addSubview:self.protractor];
    [self.view addSubview:self.angleLabel];
    [self.view addSubview:self.cameraButton];
}

- (void)showAngle:(CGFloat)angle
{
    self.angleLabel.text = [NSString stringWithFormat:@"%.2f°",angle];
}

- (void)clickCameraButton:(UIButton *)sender
{
    if ([self judgeCameraLimits]) {
        if (self.session.isRunning) {
            [self.session stopRunning];
            [self.videoPreviewLayer removeFromSuperlayer];
        } else {
            [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
            [self.session startRunning];
        }
    }
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
}

- (BOOL)judgeCameraLimits{
    /// 先判断摄像头硬件是否好用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        // 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            [self.view makeToast:@"摄像头访问受限,前往设置"];
            return false;
        }else{
            // 这里是摄像头可以使用的处理逻辑
            return true;
        }
    } else {
        // 硬件问题提示
        [self.view makeToast:@"请检查手机摄像头设备"];
        return false;
    }
}

- (void)dealloc
{
    if ([self judgeCameraLimits] && _session && _session.isRunning) {
        [_session stopRunning];
    }
    _session = nil;
}

@end
