//
//  QRCreaterVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/10.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "QRCreaterVC.h"
#import <CoreImage/CoreImage.h>
#import "QREditVC.h"

@interface QRCreaterVC ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation QRCreaterVC

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, Height_For_AppHeader+20, kScreenW-60, 50)];
        _titleLabel.text = @"输入想要生成二维码的文本信息..";
    }
    return _titleLabel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(30, self.titleLabel.f_bottom, kScreenW-60, 150)];
        _textView.layer.cornerRadius = 5;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.font = FFontRegular(18);
        _textView.clearsOnInsertion = true;
        _textView.delegate = self;
        
    }
    return _textView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(30, self.textView.f_bottom+50, kScreenW-60, 50);
        _button.layer.cornerRadius = 5;
        [_button setBackgroundColor:[UIColor whiteColor]];
        [_button setTitleColor:CommonBlueColor forState:UIControlStateNormal];
        [_button setTitle:@"生成二维码" forState:UIControlStateNormal];
        
        [_button addTarget:self action:@selector(clickCreateQR:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码生成";
    self.view.backgroundColor = FColor(0xee, 0xee, 0xee);
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.button];
    
    
}

- (void)clickCreateQR:(UIButton *)sender
{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据<字符串长度893>
    NSData *data = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    //获取二维码过滤器生成二维码
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFromCIImage:image WithSize:kScreenW-40];
    
    QREditVC *vc = [[QREditVC alloc] initWithQRImage:img];
    [self.navigationController pushViewController:vc animated:true];
}

//二维码清晰
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image WithSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
