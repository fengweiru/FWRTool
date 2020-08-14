//
//  ColorSliderView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/12.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ColorSliderView;
@protocol ColorSliderViewDelegate <NSObject>

- (void)changeValue:(float)value colorSliderView:(ColorSliderView *)colorSliderView;

@end

@interface ColorSliderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) float maxValue;
@property (nonatomic, assign) float value;
@property (nonatomic, strong) NSString *unit;

@property (nonatomic, assign) id<ColorSliderViewDelegate> delegate;

- (void)setTitle:(NSString *)title maxValue:(float)maxValue unit:(NSString *)unit;

@end

NS_ASSUME_NONNULL_END
