//
//  QREditVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/10.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "QREditVC.h"
#import "QRWrittenVC.h"

#import <Photos/Photos.h>

@interface QREditVC ()<QRWrittenVCDelegate>

@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UILabel *stringLabel;

@property (nonatomic, strong) UIView *toolView;

@end

@implementation QREditVC

- (UIView *)editView
{
    if (!_editView) {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(10, Height_For_AppHeader+10, kScreenW-20, kScreenW-20)];
        _editView.backgroundColor = [UIColor whiteColor];
        
        [_editView addSubview:self.qrImageView];
        [_editView addSubview:self.stringLabel];
    }
    return _editView;
}

- (UIImageView *)qrImageView
{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenW-40, kScreenW-40)];
    }
    return _qrImageView;
}

- (UILabel *)stringLabel
{
    if (!_stringLabel) {
        _stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.qrImageView.f_bottom, self.editView.f_width, 50)];
        _stringLabel.textAlignment = NSTextAlignmentCenter;
        _stringLabel.font = FFontSemibold(30);
        _stringLabel.hidden = true;
    }
    return _stringLabel;
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-80, kScreenW, 80)];
        _toolView.backgroundColor = [UIColor whiteColor];
        
        UIButton *writtenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        writtenButton.frame = CGRectMake(kScreenW/2-40, 0, 80, 80);
        [writtenButton setTitle:@"添加文字" forState:UIControlStateNormal];
        [writtenButton setTitleColor:CommonBlueColor forState:UIControlStateNormal];
        [writtenButton addTarget:self action:@selector(clickWrittenButton:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:writtenButton];
    }
    return _toolView;
}

- (instancetype)initWithQRImage:(UIImage *)qrImage
{
    if (self = [super init]) {
        [self.qrImageView setImage:qrImage];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码";
    self.view.backgroundColor = FColor(0xee, 0xee, 0xee);
    [self setNavRightItemWithTitle:@"保存二维码"];
    
    [self.view addSubview:self.editView];
    [self.view addSubview:self.toolView];
}

- (void)clickRightItem:(UIButton *)sender
{
    UIImage *qrImage = [self screenShotView:self.editView];
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:qrImage];
      } error:&error];
    
    if (!error) {
        [self.view makeToast:@"保存成功！"];
    }
}

- (void)clickWrittenButton:(UIButton *)sender
{
    QRWrittenVC *vc = [[QRWrittenVC alloc] initWithString:self.stringLabel.text];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -- 代理
- (void)writtenString:(NSString *)string
{
    self.stringLabel.text = string;
    if (string.length > 0) {
        self.editView.f_height = kScreenW-20+50;
        self.stringLabel.hidden = false;
    } else {
        self.editView.f_height = kScreenW-20;
        self.stringLabel.hidden = true;
    }
}

// 对指定视图进行截图
- (UIImage *)screenShotView:(UIView *)view
{
    UIImage *imageRet = nil;
    
    if (view)
    {
        if(UIGraphicsBeginImageContextWithOptions)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        }
        else
        {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        
        //获取图像
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageRet = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
    }
    
    return imageRet;
}

@end
