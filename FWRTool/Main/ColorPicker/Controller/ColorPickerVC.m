//
//  ColorPickerVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/7/31.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ColorPickerVC.h"
#import "UIView+Color.h"
#import "FWRMagnifierView.h"
#import "ColorPaletteView.h"

@interface ColorPickerVC ()<ColorPaletteViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ColorPaletteView *colorPaletteView;
@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) FWRMagnifierView *magnifierView;

@end

@implementation ColorPickerVC

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"test"];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW-300)/2, Height_For_AppHeader+10, 300, kScreenH-(Height_For_AppHeader+10+self.colorPaletteView.f_height+self.colorLabel.f_height+10))];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.f_width = image.size.width/image.size.height * _imageView.f_height;
        _imageView.f_x = (kScreenW-_imageView.f_width)/2;
    }
    return _imageView;
}

- (ColorPaletteView *)colorPaletteView
{
    if (!_colorPaletteView) {
        _colorPaletteView = [[ColorPaletteView alloc] init];
        _colorPaletteView.f_origin = CGPointMake(0, self.colorLabel.f_y-210);
        _colorPaletteView.delegate = self;
    }
    return _colorPaletteView;
}

- (UILabel *)colorLabel
{
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH-60, kScreenW, 60+Height_For_IphoneBottom)];
        _colorLabel.textAlignment = NSTextAlignmentCenter;
        _colorLabel.textColor = [UIColor whiteColor];
        _colorLabel.font = FFontMedium(25);
        _colorLabel.text = @"点击复制颜色RGB信息";
        
        _colorLabel.userInteractionEnabled = true;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSaveToPasteboard)];
        [_colorLabel addGestureRecognizer:tapG];
    }
    return _colorLabel;
}

- (FWRMagnifierView *)magnifierView
{
    if (!_magnifierView) {
        _magnifierView = [[FWRMagnifierView alloc] init];
        _magnifierView.renderView = self.view.window;
    }
    return _magnifierView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.title = @"取色器";
    [self setNavRightItemWithImage:[UIImage imageNamed:@"add"]];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.colorPaletteView];
    [self.view addSubview:self.colorLabel];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pickColorAction:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pickColorAction:touches];
    
    self.magnifierView = nil;
}

- (void)pickColorAction:(NSSet<UITouch *> *)touches
{
    if (touches.count > 0) {
        UITouch *touch = [touches.allObjects firstObject];
        
        CGPoint point = [touch locationInView:self.imageView];
        
        UIColor *color;
        
        if (point.x >= 0 && point.y >= 0 && point.x <= self.imageView.f_width && point.y <= self.imageView.f_height) {
            color = [self.imageView colorOfPoint:point];

            CGPoint p = [touch locationInView:self.view];
            //window的hidden默认为YES
            self.magnifierView.hidden = NO;

            //设置magnifierView的frame
            [self.magnifierView setFrame:CGRectMake(0, 0, 100, 100)];
            self.magnifierView.center = CGPointMake(p.x, p.y-25);

            //设置渲染的中心点
            self.magnifierView.renderPoint = p;
            
            [self.colorPaletteView setColor:color];
            
            self.colorLabel.text = [CommonClass toStrByUIColor:color];
            self.colorLabel.backgroundColor = color;
        } else {
//            color = self.view.backgroundColor;
//            self.magnifierView = nil;
        }
//
//        [self.colorPaletteView setColor:color];
//
//        self.colorLabel.text = [CommonClass toStrByUIColor:color];
//        self.colorLabel.backgroundColor = color;
    }
}

#pragma mark -- ColorPaletteViewDelegate
- (void)changeColor:(UIColor *)color
{
    self.colorLabel.text = [CommonClass toStrByUIColor:color];
    self.colorLabel.backgroundColor = color;
}

- (void)clickSaveToPasteboard
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[CommonClass toStrByUIColor:self.colorLabel.backgroundColor]];
    if (pasteboard == nil) {
        [self.view makeToast:@"颜色复制失败"];
    } else {
        [self.view makeToast:@"颜色复制成功"];
    }
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:true completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    self.imageView.f_width = image.size.width/image.size.height * self.imageView.f_height;
    if (self.imageView.f_width > kScreenW-20) {
        self.imageView.f_width = kScreenW-20;
        self.imageView.f_height = image.size.height/image.size.width * self.imageView.f_width;
    }
    self.imageView.f_x = (kScreenW-self.imageView.f_width)/2;
}

- (void)clickRightItem:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:true completion:^{}];
}

@end
