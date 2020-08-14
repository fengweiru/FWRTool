//
//  ColorPaletteView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/12.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorPaletteViewDelegate <NSObject>

- (void)changeColor:(UIColor *)color;

@end

typedef NS_ENUM(NSInteger,ColorPaletteType){
    ColorPaletteTypeRGB = 0,
    ColorPaletteTypeHSB = 1,
};

//固定高度250
@interface ColorPaletteView : UIView

@property (nonatomic, assign) ColorPaletteType currentType;
@property (nonatomic, assign) id<ColorPaletteViewDelegate> delegate;

@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
