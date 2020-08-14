//
//  UIColor+Conversion.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/12.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Conversion)

- (NSArray *)getRGBArray;
- (NSArray *)getHSBArray;

@end

NS_ASSUME_NONNULL_END
