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

@interface ColorPickerVC ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) FWRMagnifierView *magnifierView;

@end

@implementation ColorPickerVC

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"test"];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW-300)/2, Height_For_AppHeader+20, 300, 400)];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.f_width = image.size.width/image.size.height * _imageView.f_height;
        _imageView.f_x = (kScreenW-_imageView.f_width)/2;
    }
    return _imageView;
}

- (UILabel *)colorLabel
{
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH-80, kScreenW, 80)];
        _colorLabel.textAlignment = NSTextAlignmentCenter;
        _colorLabel.textColor = [UIColor whiteColor];
        _colorLabel.font = FFontMedium(25);
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
    [self.view addSubview:self.imageView];
    
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
            self.magnifierView.frame = CGRectMake(0, 0, 100, 100);
            self.magnifierView.center = p;
            
            //设置渲染的中心点
            self.magnifierView.renderPoint = p;
        } else {
            color = self.view.backgroundColor;
        }
        
        self.colorLabel.text = [CommonClass toStrByUIColor:color];
        self.colorLabel.backgroundColor = color;
    }
}

@end
