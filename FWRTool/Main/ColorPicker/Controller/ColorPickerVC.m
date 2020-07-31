//
//  ColorPickerVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/7/31.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ColorPickerVC.h"
#import "UIView+Color.h"

@interface ColorPickerVC ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *colorLabel;

@end

@implementation ColorPickerVC

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
        _imageView.frame = CGRectMake((kScreenW-300)/2, Height_For_AppHeader+20, 300, 400);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"取色器";
    [self.view addSubview:self.imageView];
    
    self.colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.imageView.f_bottom+40, 200, 40)];
    self.colorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.colorLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 0) {
        UITouch *touch = [touches.allObjects firstObject];
        
        CGPoint point = [touch locationInView:self.imageView];
        self.colorLabel.backgroundColor = [self.imageView colorOfPoint:point];
    }
    
}

@end
