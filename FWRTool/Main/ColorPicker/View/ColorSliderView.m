//
//  ColorSliderView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/12.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ColorSliderView.h"

@interface ColorSliderView ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation ColorSliderView

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenW-60, 30)];
        _titleLabel.font = FFontRegular(14);
        _titleLabel.textColor = FColor(0x99, 0x99, 0x99);
    }
    return _titleLabel;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 20, kScreenW-60-40, 40)];
        [_slider setMinimumValue:0];
        [_slider addTarget:self action:@selector(sliderProgressChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.slider.f_right+10, 20, 60, 40)];
        _valueLabel.font = FFontRegular(18);
        _valueLabel.textColor = FColor(0x99, 0x99, 0x99);
    }
    return _valueLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kScreenW, 60);
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.slider];
        [self addSubview:self.valueLabel];
        
    }
    return self;
}


- (void)setTitle:(NSString *)title maxValue:(float)maxValue unit:(NSString *)unit
{
    self.titleLabel.text = title;
    self.maxValue = maxValue;
    self.unit = unit;
    [self.slider setMaximumValue:self.maxValue];
    
    self.valueLabel.text = [NSString stringWithFormat:@"%0.f%@",self.value,self.unit];
}

- (void)setValue:(float)value
{
    _value = value;
    
    [self.slider setValue:value];
    self.valueLabel.text = [NSString stringWithFormat:@"%0.f%@",self.value,self.unit];
}

- (void)sliderProgressChange:(UISlider *)slider
{
    _value = slider.value;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%0.f%@",self.value,self.unit];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeValue:colorSliderView:)]) {
        [self.delegate changeValue:self.value colorSliderView:self];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kScreenW, 60);
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size = CGSizeMake(kScreenW, 60);
    [super setBounds:bounds];
}

@end
