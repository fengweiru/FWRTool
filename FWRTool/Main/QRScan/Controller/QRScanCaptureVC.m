//
//  QRScanCaptureVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/15.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "QRScanCaptureVC.h"
#import "QRScanShowVC.h"

#import <AVFoundation/AVFoundation.h>

@interface QRScanCaptureVC ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) UIButton *photoButton;

@end

@implementation QRScanCaptureVC

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
        AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];//预览
        videoPreviewLayer.frame = CGRectMake(0, Height_For_AppHeader, self.view.bounds.size.width, kScreenH-Height_For_AppHeader);
        [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];//添加预览图层
        //还可以设置扫描范围 output.rectOfInterest  不设置默认为全屏
    }
    return _session;
}

- (UIButton *)photoButton
{
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake(kScreenW/2-40, kScreenH-160, 80, 80);
//        [_photoButton setImage:[UIImage imageNamed:@"photo_icon"] forState:UIControlStateNormal];
        _photoButton.backgroundColor = [FColor(0xee, 0xee, 0xee) colorWithAlphaComponent:0.6];
        [_photoButton addTarget:self action:@selector(choicePhoto) forControlEvents:UIControlEventTouchUpInside];
        _photoButton.layer.masksToBounds = true;
        _photoButton.layer.cornerRadius = 40;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        imageView.image = [UIImage imageNamed:@"photo_icon"];
        [_photoButton addSubview:imageView];
    }
    return _photoButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码扫描";
    
    if ([self judgeCameraLimits]) {
        //开始扫描
        [self.session startRunning];
    }

    [self.view addSubview:self.photoButton];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self playBeep];
    [self.session stopRunning];
    
    NSString *content = @"";
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    content = metadataObject.stringValue;//获取到二维码中的信息字符串
    //对此字符串进行处理(音效、网址分析、页面跳转等)
    QRScanShowVC *vc = [[QRScanShowVC alloc] initWithContent:content];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)playBeep{
    SystemSoundID soundID = 1007;
//      AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"滴-2"ofType:@"mp3"]], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//从相册获取二维码
- (void)choicePhoto{
    //调用相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//选中图片的回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:true completion:nil];
    
    NSString *content = @"" ;
    //取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];

    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];

    //取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        content = result.messageString;
    }
    
    if (content.length > 0) {
      //进行处理(音效、网址分析、页面跳转等)
      QRScanShowVC *vc = [[QRScanShowVC alloc] initWithContent:content];
      [self.navigationController pushViewController:vc animated:true];
    } else {
        [self.view makeToast:@"未发现二维码信息"];
    }
    
}

- (void)dealloc
{
    if ([self judgeCameraLimits] && _session) {
        [_session stopRunning];
    }
    _session = nil;
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


@end
