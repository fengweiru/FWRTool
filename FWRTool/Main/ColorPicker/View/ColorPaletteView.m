//
//  ColorPaletteView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/12.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ColorPaletteView.h"
#import "ColorSliderView.h"
#import "UIColor+Conversion.h"

@interface ColorPaletteView ()<ColorSliderViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) ColorSliderView *sliderR;
@property (nonatomic, strong) ColorSliderView *sliderG;
@property (nonatomic, strong) ColorSliderView *sliderB;

@property (nonatomic, strong) ColorSliderView *sliderH;
@property (nonatomic, strong) ColorSliderView *sliderS;
@property (nonatomic, strong) ColorSliderView *sliderB2;

@end

@implementation ColorPaletteView

- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"RGB",@"HSB"]];
        _segmentControl.frame = CGRectMake(30, 0, kScreenW-60, 30);
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(swicthType:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (ColorSliderView *)sliderR
{
    if (!_sliderR) {
        _sliderR = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, 30, 0, 0)];
        [_sliderR setTitle:@"Red(红)" maxValue:255 unit:@""];
        _sliderR.delegate = self;
    }
    return _sliderR;
}
- (ColorSliderView *)sliderG
{
    if (!_sliderG) {
        _sliderG = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, self.sliderR.f_bottom, 0, 0)];
        [_sliderG setTitle:@"Green(绿)" maxValue:255 unit:@""];
        _sliderG.delegate = self;
    }
    return _sliderG;
}
- (ColorSliderView *)sliderB
{
    if (!_sliderB) {
        _sliderB = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, self.sliderG.f_bottom, 0, 0)];
        [_sliderB setTitle:@"Blue(蓝)" maxValue:255 unit:@""];
        _sliderB.delegate = self;
    }
    return _sliderB;
}

- (ColorSliderView *)sliderH
{
    if (!_sliderH) {
        _sliderH = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, 30, 0, 0)];
        [_sliderH setTitle:@"Hue(色相)" maxValue:359 unit:@"°"];
        _sliderH.delegate = self;
        _sliderH.hidden = true;
    }
    return _sliderH;
}
- (ColorSliderView *)sliderS
{
    if (!_sliderS) {
        _sliderS = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, self.sliderH.f_bottom, 0, 0)];
        [_sliderS setTitle:@"Saturation(饱和度)" maxValue:100 unit:@"%"];
        _sliderS.delegate = self;
        _sliderS.hidden = true;
    }
    return _sliderS;
}
- (ColorSliderView *)sliderB2
{
    if (!_sliderB2) {
        _sliderB2 = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, self.sliderS.f_bottom, 0, 0)];
        [_sliderB2 setTitle:@"Brightness(亮度)" maxValue:100 unit:@"%"];
        _sliderB2.delegate = self;
        _sliderB2.hidden = true;
    }
    return _sliderB2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kScreenW, 210);
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.segmentControl];
        
        [self addSubview:self.sliderR];
        [self addSubview:self.sliderG];
        [self addSubview:self.sliderB];
        
        [self addSubview:self.sliderH];
        [self addSubview:self.sliderS];
        [self addSubview:self.sliderB2];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (void)swicthType:(UISegmentedControl *)segmentControl
{
    self.currentType = segmentControl.selectedSegmentIndex;
    
    if (self.currentType == ColorPaletteTypeRGB) {
        self.sliderH.hidden = true;
        self.sliderS.hidden = true;
        self.sliderB2.hidden = true;
        
        self.sliderR.hidden = false;
        self.sliderG.hidden = false;
        self.sliderB.hidden = false;
        
    } else {
        self.sliderH.hidden = false;
        self.sliderS.hidden = false;
        self.sliderB2.hidden = false;
        
        self.sliderR.hidden = true;
        self.sliderG.hidden = true;
        self.sliderB.hidden = true;
    }
    
    self.color = _color;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    if (self.currentType == ColorPaletteTypeRGB) {
        NSArray *rgbArray = [color getRGBArray];
        [self.sliderR setValue:[rgbArray[0] floatValue]];
        [self.sliderG setValue:[rgbArray[1] floatValue]];
        [self.sliderB setValue:[rgbArray[2] floatValue]];
    } else {
        NSArray *hsbArray = [color getHSBArray];
        [self.sliderH setValue:[hsbArray[0] floatValue]];
        [self.sliderS setValue:[hsbArray[1] floatValue]];
        [self.sliderB2 setValue:[hsbArray[2] floatValue]];
    }
}

#pragma mark -- ColorSliderView
- (void)changeValue:(float)value colorSliderView:(ColorSliderView *)colorSliderView
{
    if (self.currentType == ColorPaletteTypeRGB) {
        
        _color = [UIColor colorWithRed:self.sliderR.value/255.0 green:self.sliderG.value/255.0 blue:self.sliderB.value/255.0 alpha:1.0];
        
    } else {
        
        _color = [UIColor colorWithHue:self.sliderH.value/360.0 saturation:self.sliderS.value/100.0 brightness:self.sliderB2.value/100.0 alpha:1.0];
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeColor:)]) {
        [self.delegate changeColor:self.color];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kScreenW, 210);
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size = CGSizeMake(kScreenW, 210);
    [super setBounds:bounds];
}

@end
